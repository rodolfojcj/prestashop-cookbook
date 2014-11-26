#
# Cookbook Name:: prestashop
# Definition:: other_modules
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

define :prestashop_other_modules, :base_dir => nil, :dir_owner => nil,
    :dir_group => nil, :other_modules => nil do

  params[:base_dir] = params[:base_dir] || node['prestashop']['base_dir']
  params[:dir_owner] = params[:dir_owner] || node['prestashop']['dir_owner']
  params[:dir_group] = params[:dir_group] || node['prestashop']['dir_group']

  modules_dir = ::File.join(params[:base_dir], 'modules')

  package "git" if params[:other_modules]['via_git'].size > 0

  #
  params[:other_modules]['via_git'].each do |ps_module|
    git ::File.join(modules_dir, ps_module['name']) do
      user params[:dir_owner]
      group params[:dir_group]
      repository ps_module['url']
      revision ps_module['rev']
      action :sync
    end
  end
end
