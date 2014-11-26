#
# Cookbook Name:: prestashop
# Definition:: piwik
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

define :prestashop_piwik, :base_dir => nil, :dir_owner => nil,
    :dir_group => nil do

  params[:base_dir] = params[:base_dir] || node['prestashop']['base_dir']
  params[:dir_owner] = params[:dir_owner] || node['prestashop']['dir_owner']
  params[:dir_group] = params[:dir_group] || node['prestashop']['dir_group']

  modules_dir = ::File.join(params[:base_dir], 'modules')

  package 'subversion'

  bash 'get-piwik-module-via-svn-export' do
    user params[:dir_owner]
    group params[:dir_group]
    cwd modules_dir
    code 'svn export https://github.com/sutunam/Advanced-Piwik-Prestashop/trunk/Prestashop%201.5/piwik'
    not_if {Dir.exists?(::File.join(modules_dir, 'piwik'))}
  end
end
