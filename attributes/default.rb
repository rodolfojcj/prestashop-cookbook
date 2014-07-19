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
default['prestashop']['custom_admin_dir'] = 'store-admin-' + rand(1000..9999).to_s
default['prestashop']['install_dir'] = 'install'
default['prestashop']['settings_file'] = 'config/settings.inc.php'
default['prestashop']['dir_owner'] = 'www-data'
default['prestashop']['dir_group'] = 'www-data'
#
default['prestashop']['old_downloads_url_prefix'] = 'http://www.prestashop.com/download/old'
default['prestashop']['version'] = '1.6.0.8'
#
default['prestashop']['db_server'] = '127.0.0.1'
default['prestashop']['db_name'] = 'prestashop_db'
default['prestashop']['db_user'] = 'prestashop_user'
default['prestashop']['db_password'] = 'V2ryD3ff3c5lt_'
default['prestashop']['db_prefix'] = ''
default['prestashop']['install_db'] = true
#
default['prestashop']['domain'] = 'www.myprestashop.com'
default['prestashop']['email'] = 'sells@myprestashop.com'
default['prestashop']['password'] = 'V2ryStr4ng_'
default['prestashop']['store_name'] = 'My_Prestashop'
default['prestashop']['timezone'] = 'America/Caracas'
default['prestashop']['language'] = 'es'
default['prestashop']['country'] = 've'
default['prestashop']['newsletter'] = '0'
#
default['prestashop']['install_via_cli'] = true
default['prestashop']['install_cli_options'] = {
  'domain' => node['prestashop']['domain'],
  'db_server' => node['prestashop']['db_server'],
  'db_user' => node['prestashop']['db_user'],
  'db_password' => node['prestashop']['db_password'],
  'db_name' => node['prestashop']['db_name'],
  'email' => node['prestashop']['email'],
  'password' => node['prestashop']['password'],
  'name' => node['prestashop']['store_name'],
  'timezone' => node['prestashop']['timezone'],
  'language' => node['prestashop']['language'],
  'country' => node['prestashop']['country'],
  'newsletter' => node['prestashop']['newsletter'],
  'prefix' => node['prestashop']['db_prefix']
}
#
#http://www.prestashop.com/download/lang_packs/gzip/1.6.0.7/es.gzip
default['prestashop']['translations_url_prefix'] = 'http://www.prestashop.com/download/lang_packs/gzip'
default['prestashop']['translations'] = {'es' => '1.6.0.7'}
#
default['prestashop']['do_cleanup'] = true
#
default['prestashop']['vhost_name'] = 'myprestashop'
default['prestashop']['use_ssl_with_vhost'] = false
default['prestashop']['apache_ssl_params'] = {
  'SSLCertificateFile' => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  'SSLCertificateKeyFile' => '/etc/ssl/private/ssl-cert-snakeoil.key',
  '#SSLCertificateChainFile' => '??/etc/ssl/certs/ssl-cert-snakeoil.pem',
  '#SSLCACertificateFile' => '??/etc/ssl/certs/GS_AlphaSSL_CA_bundle.crt'
}
