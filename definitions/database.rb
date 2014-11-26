#
# Cookbook Name:: prestashop
# Definition:: database
#
# Copyright 2014, OpenSinergia
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

define :prestashop_database, :db_server_host => nil, :db_server_port => nil,
    :db_superuser => nil, :db_superpassword => nil,
    :db_name => nil, :db_user => nil, :db_password => nil do

  params[:db_server_host] = params[:db_server_host] || node['prestashop']['db_server_host']
  params[:db_server_port] = params[:db_server_port] || node['prestashop']['db_server_port']
  params[:db_superuser] = params[:db_superuser] || 'root'
  params[:db_superpassword] = params[:db_superpassword] || node['mysql']['server_root_password']
  params[:db_name] = params[:db_name] || node['prestashop']['db_name']
  params[:db_user] = params[:db_user] || node['prestashop']['db_user']
  params[:db_password] = params[:db_password] || node['prestashop']['db_password']

  include_recipe "mysql::server"
  include_recipe "database"

  mysql_connection_info = {
    :host     => params[:db_server_host],
    :username => params[:db_superuser],
    :password => params[:db_superpassword]
  }

  mysql_database params[:db_name] do
      connection mysql_connection_info
      action [:create]
  end

  mysql_database_user params[:db_user] do
    connection mysql_connection_info
    password params[:db_password]
    database_name params[:db_name]
    privileges [:all]
    action [:create, :grant]
  end
end
