#
# Cookbook Name:: prestashop
# Recipe:: php5_mcrypt
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

package 'php5-mcrypt'

bash 'enable-php5-mcrypt-extension' do
  code '/usr/sbin/php5enmod mcrypt'
  only_if {
    ('debian' == node['platform'] && Chef::VersionConstraint.new('>= 7.0').include?(node['platform_version'])) ||
    ('ubuntu' == node['platform'] && Chef::VersionConstraint.new('>= 12.10').include?(node['platform_version']))
  }
  notifies :reload, "service[apache2]", :delayed
end
