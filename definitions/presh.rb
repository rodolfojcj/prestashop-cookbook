#
# Cookbook Name:: prestashop
# Definition:: presh
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

define :prestashop_presh, :base_dir => nil, :dir_owner => nil,
    :dir_group => nil, :presh_dir => nil, :commands => nil do

  params[:base_dir] = params[:base_dir] || node['prestashop']['base_dir']
  params[:dir_owner] = params[:dir_owner] || node['prestashop']['dir_owner']
  params[:dir_group] = params[:dir_group] || node['prestashop']['dir_group']
  params[:presh_dir] = params[:presh_dir] || (
    node['prestashop']['presh']['install_dir_base'] +
    node['prestashop']['presh']['install_dir_suffix']
  )

  bash 'apply-presh-commands' do
    user params[:dir_owner]
    group params[:dir_group]
    presh_exec = ::File.join(params[:presh_dir], 'presh')
    bash_commands = ''
    params[:commands].each do |command|
      bash_commands << <<-EOH
        #{presh_exec} #{command['name']} #{command['params'] || ''}
      EOH
    end
    cwd params[:base_dir]
    code bash_commands
    not_if {params[:commands].empty?}
  end
end
