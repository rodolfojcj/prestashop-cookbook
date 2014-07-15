#
# Cookbook Name:: prestashop
# Recipe:: apache_vhost
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

web_app node['prestashop']['vhost_name'] do
  server_name node['prestashop']['domain']
  docroot node['prestashop']['base_dir']
  template 'apache_vhost.conf.erb' if node['prestashop']['use_ssl_with_vhost'] == false
  if node['prestashop']['use_ssl_with_vhost'] == true
    template 'apache_vhost_ssl.conf.erb'
    ssl_params node['prestashop']['apache_ssl_params']
  end
  log_dir node['apache']['log_dir']
end

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl" if node['prestashop']['use_ssl_with_vhost'] == true
