#
# Cookbook Name:: prestashop
# Recipe:: presh
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

install_dir = node.default['prestashop']['presh']['install_dir_base'] +
  node.default['prestashop']['presh']['install_dir_suffix'] + '/'
revision = node.default['prestashop']['presh']['revision']

bash 'get-presh-from-github' do
  download_url = node.default['prestashop']['presh']['base_url'] +
    node.default['prestashop']['presh']['revision'] + '.zip'
  downloaded_file_name = 'presh-' + revision + '.zip'
  # downloaded_directory will contain our target directory (e.g presh-master)
  downloaded_directory = 'presh-' + node.default['prestashop']['presh']['revision']
  code <<-EOH
    wget --continue --quiet #{download_url} --output-document=#{downloaded_file_name}
    unzip -o #{downloaded_file_name}
    rm -rf #{install_dir}
    mv #{downloaded_directory} #{install_dir}
    chmod 755 #{install_dir}presh
    rm -f #{downloaded_file_name}
  EOH
  only_if {
    keep_updating = node.default['prestashop']['presh']['keep_updating']
    Dir.exists?(install_dir) == false || (keep_updating == true && revision == 'master')
  }
end

bash 'apply-presh-commands' do
  user node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  presh_exec = install_dir + 'presh'
  bash_commands = ''
  node.default['prestashop']['presh']['commands'].each do |command|
    bash_commands << <<-EOH
      #{presh_exec} #{command['name']} #{command['params'] || ''}
    EOH
  end
  cwd node.default['prestashop']['base_dir']
  code bash_commands
  only_if {!node.default['prestashop']['presh']['commands'].empty?}
end
