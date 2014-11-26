#
# Cookbook Name:: prestashop
# Attributes:: default
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

#
default['prestashop']['base_dir'] = '/var/www/prestashop'
default['prestashop']['default_admin_dir'] = 'admin'
default['prestashop']['install_dir'] = 'install'
default['prestashop']['settings_file'] = ::File.join('config', 'settings.inc.php')
default['prestashop']['dir_owner'] = 'www-data'
default['prestashop']['dir_group'] = 'www-data'
#
default['prestashop']['old_downloads_url_prefix'] = 'http://www.prestashop.com/download/old'
default['prestashop']['version'] = '1.6.0.9'
#
default['prestashop']['db_server_host'] = '127.0.0.1'
default['prestashop']['db_server_port'] = '127.0.0.1'
default['prestashop']['db_name'] = 'prestashop_db'
default['prestashop']['db_user'] = 'prestashop_user'
default['prestashop']['db_password'] = 'V2ryD3ff3c5lt_'
default['prestashop']['db_prefix'] = ''
#
default['prestashop']['domain'] = 'www.myprestashop.com'
#
#http://www.prestashop.com/download/lang_packs/gzip/1.6.0.9/es.gzip
default['prestashop']['translations_url_prefix'] = 'http://www.prestashop.com/download/lang_packs/gzip'
default['prestashop']['translations'] = {'es' => '1.6.0.9'}
#
default['prestashop']['vhost_name'] = 'myprestashop'
# mcrypt usage is optional; it's possible to ignore it
# see http://www.prestashop.com/forums/topic/252553-fatal-error-call-to-undefined-function-mcrypt-encrypt/
default['prestashop']['with_php5_mcrypt'] = true
default['prestashop']['need_imap_for_service_client'] = true
