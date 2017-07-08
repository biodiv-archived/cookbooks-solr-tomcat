default[:solr][:version]   = "4.10.1"
default[:solr][:workingDir] = "/usr/local/src"
default[:solr][:dataimporthandler_url] = "http://central.maven.org/maven2/org/apache/solr/solr-dataimporthandler/#{solr.version}/solr-dataimporthandler-#{solr.version}.jar"
if solr.version.split('.').first.to_i >= 4
  default[:solr][:link]      = "https://archive.apache.org/dist/lucene/solr/#{solr.version}/solr-#{solr.version}.tgz"
  default[:solr][:download]  = "#{solr.workingDir}/solr-#{solr.version}.tgz"
  default[:solr][:extracted] = "#{solr.workingDir}/solr-#{solr.version}"
  default[:solr][:war]       = "#{solr.extracted}/dist/solr-#{solr.version}.war"
else
  default[:solr][:link]      = "http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
  default[:solr][:download]  = "#{solr.workingDir}/apache-solr-#{solr.version}.tgz"
  default[:solr][:extracted] = "#{solr.workingDir}/apache-solr-#{solr.version}"
  default[:solr][:war]       = "#{solr.extracted}/dist/apache-solr-#{solr.version}.war"
end

default[:solr][:home]          = "/var/local/solr-#{solr.version}"
default[:solr][:context_path]  = 'solr'
default[:solr][:data]          = "/var/local/solr-#{solr.version}/data"
default[:solr][:custom_config] = nil
default[:solr][:custom_lib]    = nil
default[:solr][:tomcat_instance]    = "solr"
