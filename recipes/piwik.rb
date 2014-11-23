#
# Cookbook Name:: prestashop
# Recipe:: piwik
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

package 'subversion'

modules_dir = ::File.join(node['prestashop']['base_dir'], 'modules')

node['prestashop']['other_modules']['via_git'].each do |ps_module|
  git ::File.join(modules_dir, ps_module['name']) do
    user node['prestashop']['dir_owner']
    group node['prestashop']['dir_group']
    repository ps_module['url']
    revision ps_module['rev']
    action :sync
  end
end

bash 'get-piwik-module-via-svn-export' do
  user node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  cwd modules_dir
  code 'svn export https://github.com/sutunam/Advanced-Piwik-Prestashop/trunk/Prestashop%201.5/piwik'
  not_if {Dir.exists?(::File.join(modules_dir, 'piwik'))}
end
