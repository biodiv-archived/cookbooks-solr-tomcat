solr-tomcat Cookbook
=============
Installs and configures solr to run on tomcat application server.

Requirements
============

## Platforms

* Ubuntu 14.04 LTS

Tested on:

* Ubuntu 14.04 LTS


### Cookbooks
Requires the following cookbooks

* `tomcat`
* `application_java`


Attributes
============

* `node[:solr][:version]` - The solr version to install.
* `node[:solr][:workingDir]` - Temporary working directory that the cookbook uses to download and extract solr.
* `node[:solr][:link]` - Solr download link. By default created using the solr version attribute above.

* `node[:solr][:home]` - The folder where solr war would be hosted for tomcat to read.
* `node[:solr][:context_path]` - The name of the solr context when deployed to tomcat.
* `node[:solr][:data]` - Location where solr would store data files.

The default values for these attributes can be found in `attributes/default.rb`


Recipes
=======
* `default.rb` - Downloads solr and deploys it to tomcat.

Chef Solo Note
==============

You can install solr on tomcat as follows.

Create a file solr.json with the following contents. 

    {
        "solr-tomcat": {
            "data": "/usr/local/solr-data"
        },
        "tomcat": {
            "base_version": "7"
        },
        "java": {
            "jdk_version": "7"
        },
        "run_list": [
            "recipe[solr-tomcat]"
        ]
    }

License and Author
==================

- Author:: Ashish Shinde (<ashish@strandls.com>)
- Author:: Sandeep Tadekar (<sandeept@strandls.com>)
- Author:: Prabhakar Rajagopal (<prabha@strandls.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
