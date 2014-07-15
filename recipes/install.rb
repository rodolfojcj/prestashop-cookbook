#
# Cookbook Name:: prestashop
# Recipe:: install
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

package 'php5-cli'
package 'php5-mysql'
package 'tar'
package 'wget'
package 'unzip'

directory node['prestashop']['base_dir'] do
  owner node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  mode '0750'
  recursive true
end

base_dir = node['prestashop']['base_dir']
default_admin_dir = base_dir + "/" + node['prestashop']['default_admin_dir']
custom_admin_dir = base_dir + "/" + node['prestashop']['custom_admin_dir']
install_dir = base_dir + "/" + node['prestashop']['install_dir']
settings_file = base_dir + "/" + node['prestashop']['settings_file']
already_installed = File.exists?(settings_file)

bash 'get-prestashop-core' do
  user node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  cwd Chef::Config[:file_cache_path]
  zip_file = 'prestashop_' + node['prestashop']['version'] + '.zip'
  zip_file = node['prestashop']['zip_file']
  full_download_url = node['prestashop']['full_download_url']
  code <<-EOH
    tmp_dir=$(mktemp -d)
    #wget --continue --quiet #{full_download_url} && unzip -o #{zip_file} -d $tmp_dir && rm #{zip_file}
    wget --continue --quiet #{full_download_url} && unzip -o #{zip_file} -d $tmp_dir
    # no hidden files downloaded, so it is safe to use mv
    mv $tmp_dir/prestashop/* #{base_dir}
    rm -rf $tmp_dir
    mv #{default_admin_dir} #{custom_admin_dir}
  EOH
  not_if {already_installed == true}
end

bash 'get-prestashop-translations' do
  user node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  cwd base_dir
  bash_commands = ''
  node['prestashop']['translations'].each { |lang, version|
    bash_commands << <<-EOH
      wget --quiet -O - #{node['prestashop']['translations_url_prefix']}/#{version}/#{lang}.gzip | tar xzf -
    EOH
  }
  code bash_commands
  not_if {already_installed == true}
end

bash 'install-prestashop-via-cli' do
  user node['prestashop']['dir_owner']
  group node['prestashop']['dir_group']
  cwd install_dir
  #node.default['prestashop']['install_cli_options']['language'] = 'it'
  #cli_options = node['prestashop']['install_cli_options'].map{|k,v| [" --#{k}=", "#{v}"]}.join('')
  opts_hash = node['prestashop']['install_cli_options']
  cli_options = opts_hash.map{|k,v|
    [(opts_hash[k] != opts_hash[opts_hash.keys.first] ? " " : "") + "--#{k}=", "#{v}"]
  }.join('')
  code <<-EOH
    php index_cli.php #{cli_options}
    rm -rf #{install_dir}
  EOH
  only_if {
    Dir.exists?(install_dir) == true &&
    already_installed == false &&
    node['prestashop']['install_via_cli'] == true
  }
end

bash 'clean-unneeded-prestashop-files' do
  cwd base_dir
  code <<-EOH
    find . -iname '*.md' -type f -exec rm \{\} \\;
    find . -iname '.gitignore' -type f -exec rm \{\} \\;
    find . -iname 'CHANGELOG.txt' -type f -exec rm \{\} \\;
    find . -iname 'LICENSE.txt' -type f -exec rm \{\} \\;
    find . -iname '.git' -type d -exec rm \{\} \\;
    rm -rf docs
  EOH
  only_if {node['prestashop']['do_cleanup'] == true}
end

##
# TODO
##
# - I have installed v 1.5.1 and the desired non installed version is 1.5.2. How to manage this?
