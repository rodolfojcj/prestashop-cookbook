#
# Cookbook Name:: prestashop
# Definition:: apache_vhost
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

define :prestashop_apache_vhost, :app_name => nil, :app_domain => nil,
    :base_dir => nil, :template => 'apache_vhost.conf.erb',
    :ssl_params => nil, :app_aliases => nil,
    :templates_cookbook => 'prestashop', :log_dir => nil do

  params[:app_name] = params[:app_name] || node['prestashop']['vhost_name']
  params[:app_domain] = params[:app_domain] || node['prestashop']['domain']
  params[:base_dir] = params[:base_dir] || node['prestashop']['base_dir']
  params[:ssl_params] = params[:ssl_params] || node['prestashop']['ssl_params']
  params[:log_dir] = params[:log_dir] || node['apache']['log_dir']

  # See http://gettingstartedwithchef.com/more-than-one-website.html for reference
  # It is due to a limitation of Ruby scoping, so dup_params is a workaround
  dup_params = params

  web_app params[:app_name] do
    server_name dup_params[:app_domain]
    server_aliases dup_params[:app_aliases] if dup_params[:app_aliases] && !dup_params[:app_aliases].join.empty?
    docroot dup_params[:base_dir]
    cookbook dup_params[:templates_cookbook]
    template dup_params[:template]
    ssl_params dup_params[:ssl_params]
    log_dir dup_params[:log_dir]
  end

  include_recipe "apache2"
  include_recipe "apache2::mod_php5"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_ssl" if params[:ssl_params].size > 0
end
