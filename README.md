prestashop Cookbook
===================
Cookbook for installing and configuring e-commerce web sites based
on [Prestashop](http://www.prestashop.com), an Open Source web
e-commerce solution.

Requirements
------------
#### Packages
The following packages are installed by this cookbook:

- `php5-cli`
- `php5-gd`
- `php5-mysql`
- `tar`
- `wget`
- `unzip`

Also the packages `php5-mcrypt` and `php5-imap` will be installed by
default, but the user can exclude them.

#### Cookbooks

- `apache2`
- `database`
- `mysql`

Attributes
----------
#### prestashop::default

- `node['prestashop']['base_dir']` - directory where Prestashop will be installed (default /var/www/prestashop)
- `node['prestashop']['default_admin_dir']` - name of default admin directory
- `node['prestashop']['install_dir']` - name of default install directory
- `node['prestashop']['settings_file']` - path to config file (default 'config/settings.inc.php')
- `node['prestashop']['dir_owner']` - owner of installation directory (default 'www-data')
- `node['prestashop']['dir_group']` - group of installation directory (default 'www-data')
- `node['prestashop']['old_downloads_url_prefix']` - URL to get several Prestashop versions (default 'http://www.prestashop.com/download/old')
- `node['prestashop']['version']` - Prestashop version to install (default '1.6.0.8')
- `node['prestashop']['db_server_host']` - database server host to use (default '127.0.0.1')
- `node['prestashop']['db_server_port']` - database server port to use (default '3306')
- `node['prestashop']['db_name']` - database name to use (default 'prestashop_db')
- `node['prestashop']['db_user']` - database user (default 'prestashop_user')
- `node['prestashop']['db_password']` - database password (default 'V2ryD3ff3c5lt_')
- `node['prestashop']['db_prefix']` - prestashop database tables prefix (default '')
- `node['prestashop']['domain']` - store URL (default 'www.myprestashop.com')
- `node['prestashop']['translations_url_prefix']` - URL to download several translation files
- `node['prestashop']['vhost_name']` - virtual host file name to use when configuring Apache web site
- `node['prestashop']['with_php5_mcrypt']` - install and enable PHP mcrypt extension (yes/no, default true)
- `node['prestashop']['need_imap_for_service_client']` - whether to install and configure php IMAP extension (boolean, true by default)

#### prestashop::presh

- `node['prestashop']['presh']['enabled']` - whether to use or not [Presh](http://github.com/rodolfojcj/presh) (boolean, `false` by default because it is so experimental)
- `node['prestashop']['presh']['base_url']` - github repository base url to download Presh from (`https://github.com/rodolfojcj/presh/archive/` by default)
- `node['prestashop']['presh']['revision']` - github repository branch, tag or revision of Presh to use (`master` by default, but it also could be something like `c48cdd316d0c32c4f6958ade91b738b12a1c1330`)
- `node['prestashop']['presh']['install_dir_base']` - base name of the directory where Presh will be installed in the node (default is `/usr/local/presh`)
- `node['prestashop']['presh']['install_dir_suffix']` - name suffix of the directory where Presh will be installed in the node (default is the concatenation of a `-` sign and the value of `node.default['prestashop']['presh']['revision']`)
- `node['prestashop']['presh']['keep_updating']` - whether to re-download a possible new version of Presh from the repository (boolean, `true` by default). No matter which value it has, it only will be useful when the revision used is `master`.

Recipes
-------

- `prestashop::default`: main and simple recipe, just invokes the other recipes (conditionally in some cases)
- `prestashop::php5_imap`: installs php5 IMAP extension and enables it (only in Debian >= 7.0 or Ubuntu >= 12.10)
- `prestashop::php5_mcrypt`: installs php5 mcrypt extension and enables it (only in Debian >= 7.0 or Ubuntu >= 12.10)
- `prestashop::presh`: installs Presh

Usage
-----

#### Basic Usage

The idea is to use the `Prestashop cookbook` from your own wrapper
cookbooks, using its facilities with your custom parameters.

A usage example would be the following:

```
admin_dir = 'secret-admin-dir'
store_name = '"My Prestashop!"'
app_name = 'myprestashop'
domain = 'www.myprestashop.com'
aliases = ['myprestashop.com', 'awesomestore.com']
site_dir = '/var/www/myprestashop'
ssl_params = {
  'SSLCertificateFile' => '/etc/ssl/certs/myprestashop/myprestashop.crt',
  'SSLCertificateKeyFile' => '/etc/ssl/private/myprestashop/myprestashop.private.key',
  'SSLCACertificateFile' => '/etc/ssl/certs/myprestashop/CA.crt'
}
db_name = 'db_myprestashop'
db_user = 'db_user'
db_password = 'db_P1ssword'

install_cli_options = {
  'domain' => domain,
  'db_user' => db_user,
  'db_password' => db_password,
  'db_name' => db_name,
  'prefix' => '""',
  'email' => 'seller@myprestashop.com',
  'password' => 'Seller_P1ssword',
  'name' => 'MyPrestashop',
  'timezone' => 'America/Caracas',
  'language' => 'es',
  'country' => 've',
  'newsletter' => '0'
}

# the awesome module [Minic Slider from Minic Studio](http://module.minic.ro/tag/slider/)
other_modules = Hash.new
other_modules['via_git'] = [
  {
    'name' => 'minicslider',
    'url' => 'git://github.com/minicstudio/minicslider.git',
    'rev' => 'master'
  }
]

include_recipe "prestashop::default"

prestashop_database do
  db_name db_name
  db_user db_user
  db_password db_password
end

prestashop_install do
  base_dir site_dir
  custom_admin_dir admin_dir
  version '1.6.0.8'
  langs_iso_codes ['es', 'it', 'de']
  install_cli_options install_cli_options
end

prestashop_apache_vhost do
  app_name app_name
  app_domain domain
  app_aliases aliases
  base_dir site_dir
  ssl_params ssl_params
end

prestashop_other_modules do
  base_dir site_dir
  other_modules other_modules
end

```

Notice that `db_prefix` option is ignored or is not working as expected,
so some debugging will be needed to make it useful. In the meanwhile the
Prestashop installer will create every table with the `ps_ ` prefix and the
generated `settings.inc.php` config file will contain that `ps_` prefix too.

#### A bonus: Presh and Piwik

If you want to use Presh in your own cookbooks and/or install the
[Piwik](http://piwik.org) module for web analytics, take these lines
as an example:

```
...
...
node.default['prestashop']['presh']['enabled'] = true
node.default['prestashop']['presh']['revision'] = 'c48cdd316d0c32c4f6958ade91b738b12a1c1330' # 'master' is the default value
include_recipe "prestashop::default"

presh_commands = [
  {'name' => 'set_demo_mode', 'params' => '0'},
  {'name' => 'set_friendly_urls', 'params' => '1'},
  {'name' => 'set_debug_settings', 'params' => '0'},
  {'name' => 'optimize_via_ccc', 'params' => '1'},
  {'name' => 'fix_mail'},
  {'name' => 'set_smtp_mailing', 'params' => 'myprestashop.com mail.myprestashop.com mailsending@myprestashop.com MailSendinP1ssword_ TLS 25'},
  {'name' => 'update_modules'},
  {'name' => 'install_module', 'params' => 'minicslider'},
  # piwik
  {'name' => 'install_module', 'params' => 'piwik'},
  {'name' => 'update_global_value', 'params' => 'PIWIK_HOST "piwik.myprestashop.com"'},
  {'name' => 'update_global_value', 'params' => 'PIWIK_ID 1'},
  {'name' => 'update_global_value', 'params' => "PIWIK_TRACKING_TYPES 'a:4:{i:0;s:5:\"basic\";i:1;s:5:\"order\";i:2;s:4:\"view\";i:3;s:4:\"cart\";}'"},
  {'name' => 'update_global_value', 'params' => 'PIWIK_ORDER_TRACKING_STATES "b:0;"'}
]

prestashop_piwik do
  base_dir site_dir
end

prestashop_presh do
  base_dir site_dir
  commands presh_commands
end
...
...
```

Also notice that you could include the Piwik module without Presh, and later
configure it manually through the admin web interface:

```
prestashop_piwik do
  base_dir site_dir
end
```

Testing
-------

This cookbook needs automated testing, nothing has been incorporated in this respect.

Contributing
------------

Go to Github, fork it and suggest improvements or submit your issues.

License and Authors
-------------------
Author: Rodolfo Castellanos
