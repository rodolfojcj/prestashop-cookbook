#
# Cookbook Name:: prestashop
# Definition:: install
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

define :prestashop_install, :base_dir => nil, :dir_owner => nil,
    :dir_group => nil, :default_admin_dir => nil, :custom_admin_dir => nil,
    :install_dir => nil, :version => nil, :langs_iso_codes => nil,
    :install_cli_options => nil, :install_via_cli => true,
    :do_cleanup => true do

  params[:base_dir] = params[:base_dir] || node['prestashop']['base_dir']
  params[:dir_owner] = params[:dir_owner] || node['prestashop']['dir_owner']
  params[:dir_group] = params[:dir_group] || node['prestashop']['dir_group']
  params[:default_admin_dir] = params[:default_admin_dir] || node['prestashop']['default_admin_dir']
  params[:custom_admin_dir] = params[:custom_admin_dir] || 'store-admin-' + rand(1000..9999).to_s
  params[:install_dir] = params[:install_dir] || node['prestashop']['install_dir']
  params[:version] = params[:version] || node['prestashop']['version']
  params[:langs_iso_codes] = params[:langs_iso_codes] || []
  params[:install_cli_options] = params[:install_cli_options] || node['prestashop']['install_cli_options']

  default_admin_dir = ::File.join(params[:base_dir], params[:default_admin_dir])
  custom_admin_dir = ::File.join(params[:base_dir], params[:custom_admin_dir])
  install_dir = ::File.join(params[:base_dir], params[:install_dir])
  settings_file = ::File.join(params[:base_dir], node['prestashop']['settings_file'])
  already_installed = ::File.exists?(settings_file)

  package 'php5-cli'
  package 'php5-gd'
  package 'php5-mysql'
  package 'tar'
  package 'wget'
  package 'unzip'

  directory params[:base_dir] do
    owner params[:dir_owner]
    group params[:dir_group]
    mode '0750'
    recursive true
  end

  bash 'get-prestashop-core' do
    user params[:dir_owner]
    group params[:dir_group]
    download_file = 'prestashop_' + params[:version] + '.zip'
    code <<-EOH
      tmp_dir=$(mktemp -d)
      cd $tmp_dir
      wget --quiet #{node['prestashop']['old_downloads_url_prefix'] + '/prestashop_' + params[:version] + '.zip'} --output-document=#{download_file}
      unzip -o #{download_file}
      # no hidden files downloaded, so it is safe to use mv
      mv prestashop/* #{params[:base_dir]}
      mv #{default_admin_dir} #{custom_admin_dir}
      rm -rf prestashop/
    EOH
    not_if {already_installed == true}
  end

  bash 'get-prestashop-translations' do
    user params[:dir_owner]
    group params[:dir_group]
    cwd params[:base_dir]
    bash_commands = ''
    params[:langs_iso_codes].each { |lang|
      bash_commands << <<-EOH
        wget --quiet -O - #{node['prestashop']['translations_url_prefix']}/#{params[:version]}/#{lang}.gzip | tar xzf -
      EOH
    }
    code bash_commands
    not_if {already_installed == true}
  end

  bash 'install-prestashop-via-cli' do
    user params[:dir_owner]
    group params[:dir_group]
    cwd install_dir
    #node.default['prestashop']['install_cli_options']['language'] = 'it'
    #cli_options = node['prestashop']['install_cli_options'].map{|k,v| [" --#{k}=", "#{v}"]}.join('')
    opts_hash = params[:install_cli_options]
    cli_options = opts_hash.map{|k,v|
      [(opts_hash[k] != opts_hash[opts_hash.keys.first] ? " " : "") + "--#{k}=", "#{v}"]
    }.join('')
    code <<-EOH
      php index_cli.php #{cli_options}
      rm -rf #{install_dir}
    EOH
    Chef::Log.info('Installing Prestashop to ' + params[:base_dir])
    only_if {
      Dir.exists?(install_dir) == true &&
      already_installed == false &&
      params[:install_via_cli] == true
    }
  end

  bash 'clean-unneeded-prestashop-files' do
    cwd params[:base_dir]
    code <<-EOH
      find . -iname '*.md' -type f -exec rm \{\} \\;
      find . -iname '.gitignore' -type f -exec rm \{\} \\;
      find . -iname 'CHANGELOG.txt' -type f -exec rm \{\} \\;
      find . -iname 'LICENSE.txt' -type f -exec rm \{\} \\;
      find . -iname '.git' -type d -exec rm \{\} \\;
      rm -rf docs
    EOH
    only_if {params[:do_cleanup] == true}
  end

end
##
# TODO
##
# - I have installed v 1.5.1 and the desired non installed version is 1.5.2. How to manage this?
