#
# Cookbook Name:: solr-tomcat
# Recipe:: default
#
# Copyright 2014, Strand Life Sciences
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"

remote_file node.solr.download do
  source   node.solr.link
  mode     0644
  action :create_if_missing
end

bash 'unpack solr' do
  code   "tar xzf #{node.solr.download} -C #{node.solr.workingDir}"
  not_if "test -d #{node.solr.extracted}"
end

bash "Add required solr lib and deps to the war file" do
  code <<-EOH
  mkdir -p /tmp/solr-temp/WEB-INF/lib
  mkdir -p /tmp/solr-temp/WEB-INF/classes
  cd /tmp/solr-temp
  cp #{node.solr.extracted}/example/lib/ext/* WEB-INF/lib
  cp #{node.solr.extracted}/dist/solr-dataimporthandler-* WEB-INF/lib
  cp #{node.solr.extracted}/log4j.properties WEB-INF/classes
  jar -uvf #{node.solr.war} WEB-INF/lib
  jar -uvf #{node.solr.war} WEB-INF/classes
  chmod +r #{node.solr.war}
  cd -
  rm -rf /tmp/solr-temp
  EOH
end

# Setup user/group
poise_service_user "tomcat user" do
  user "tomcat"
  group "tomcat"
  shell "/bin/bash"
end

cerner_tomcat node.solr.tomcat_instance do
  version "8.5.27"
  web_app "solr" do
    source "file://#{node.solr.war}"

    template "META-INF/context.xml" do
      source "solr.context.erb"
    end
  end

  java_settings("-Xms" => "512m",
                "-D#{node.biodiv.appname}_CONFIG_LOCATION=".upcase => "#{node.biodiv.additional_config}",
                "-D#{node.biodivApi.configname}".upcase => "#{node.biodivApi.additional_config}",
                "-D#{node.fileops.appname}_CONFIG=".upcase => "#{node.fileops.additional_config}",
                "-Dlog4jdbc.spylogdelegator.name=" => "net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator",
                "-Dfile.encoding=" => "UTF-8",
                "-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=" => "true",
                "-Xmx" => "4g",
                "-XX:PermSize=" => "512m",
                "-XX:MaxPermSize=" => "512m",
                "-XX:+UseParNewGC" => "")

end

remote_directory node.solr.data do
  source       "solr"
  owner        "tomcat"
  group        "tomcat"
  files_owner  "tomcat"
  files_group  "tomcat"
  files_backup 0
  files_mode   "644"
  purge        true
  action       :create_if_missing
  recursive true
  notifies :run, "execute[change-permission-#{node.solr.data}]", :immediately
  not_if       { File.exists? node.solr.data }
end

execute "change-permission-#{node.solr.data}" do
  command "chown -R tomcat:tomcat #{node.solr.data}"
  user "root"
  action :nothing
end
