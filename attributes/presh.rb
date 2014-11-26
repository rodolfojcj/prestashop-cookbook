#
# Cookbook Name:: prestashop
# Attributes:: presh
#
# Copyright 2014, OpenSinergia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['prestashop']['presh']['enabled'] = false
default['prestashop']['presh']['base_url'] = 'https://github.com/rodolfojcj/presh/archive/'
default['prestashop']['presh']['revision'] = 'master'
default['prestashop']['presh']['install_dir_base'] = '/usr/local/presh'
default['prestashop']['presh']['install_dir_suffix'] = '-' + node['prestashop']['presh']['revision'] 
default['prestashop']['presh']['keep_updating'] = true
