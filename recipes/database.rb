#
# Cookbook Name:: prestashop
# Recipe:: database
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

include_recipe "mysql::server"
include_recipe "mysql::ruby"
include_recipe "database"

mysql_connection_info = {
  :host     => node['prestashop']['db_server'],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['prestashop']['db_name'] do
    connection mysql_connection_info
    action [:create]
end

mysql_database_user node['prestashop']['db_user'] do
  connection mysql_connection_info
  password node['prestashop']['db_password']
  database_name node['prestashop']['db_name']
  privileges [:all]
  action [:create, :grant]
end
