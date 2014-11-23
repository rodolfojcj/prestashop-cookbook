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

Also the package `php5-mcrypt` will be installed by default, but the user can exclude it.

#### Cookbooks

- `apache2`
- `database`
- `mysql`

Attributes
----------
#### prestashop::default

- `node['prestashop']['base_dir']` - directory where Prestashop will be installed (default /var/www/prestashop)
- `node['prestashop']['default_admin_dir']` - name of default admin directory
- `node['prestashop']['custom_admin_dir']` - new name for admin directory (default 'store-admin-' + rand(1000..9999).to_s)
- `node['prestashop']['install_dir']` - name of default install directory
- `node['prestashop']['settings_file']` - path to config file (default 'config/settings.inc.php')
- `node['prestashop']['dir_owner']` - owner of installation directory (default 'www-data')
- `node['prestashop']['dir_group']` - group of installation directory (default 'www-data')
- `node['prestashop']['old_downloads_url_prefix']` - URL to get several Prestashop versions (default 'http://www.prestashop.com/download/old')
- `node['prestashop']['version']` - Prestashop version to install (default '1.6.0.8')
- `node['prestashop']['db_server']` - address of database server to use (default '127.0.0.1')
- `node['prestashop']['db_name']` - database name to use (default 'prestashop_db')
- `node['prestashop']['db_user']` - database user (default 'prestashop_user')
- `node['prestashop']['db_password']` - database password (default 'V2ryD3ff3c5lt_')
- `node['prestashop']['db_prefix']` - prestashop database tables prefix (default '')
- `node['prestashop']['install_db']` - install database (yes/no, default true)

The following attributes are used on automated command line installer that comes with Prestashop:

- `node['prestashop']['domain']` - store URL (default 'www.myprestashop.com')
- `node['prestashop']['email']` - store admin email (default 'sells@myprestashop.com')
- `node['prestashop']['password']` - store admin password (default 'V2ryStr4ng_')
- `node['prestashop']['store_name']` - store name (default 'My_Prestashop')
- `node['prestashop']['timezone']` - store timezone (default 'America/Caracas')
- `node['prestashop']['language']` - store main language ISO code (default 'es')
- `node['prestashop']['country']` - store country (default 've')
- `node['prestashop']['newsletter']` - send Prestashop newsletter to admin e-mail (1=yes, 0=no. Default '0')
- `node[prestashop']['install_via_cli']` - do Prestashop installation via CLI (yes/no, default true)
- `node['prestashop']['install_cli_options']` - several options to use when installing via CLI

- `node['prestashop']['translations_url_prefix']` - URL to download several translation files
- `node['prestashop']['translations']` - ISO codes of language tranlations to download and their associated version
- `node['prestashop']['do_cleanup']` - clean several unneeded files (yes/no, default true)
- `node['prestashop']['vhost_name']` - virtual host file name to use when configuring Apache web site
- `node['prestashop']['use_ssl_with_vhost']` - use SSL in virtual host configuration (yes/no, default false)
- `node['prestashop']['apache_ssl_params']` - several SSL params used when configuring Apache virtual host
- `node['prestashop']['with_php5_mcrypt']` - install and enable PHP mcrypt extension (yes/no, default true)
- `node['prestashop']['need_imap_for_service_client']` - whether to install and configure php IMAP extension (boolean, true by default)
- `node['prestashop']['other_modules']['via_git']` - array of hashes, where each entry contains the details to get a remote Prestashop module via Git
- `node['prestashop']['other_modules']['get_piwik']` - whether to get the Piwik module for web analytics (boolean, false by default)

#### prestashop::presh

- `node['prestashop']['presh']['enabled']` - whether to use or not [Presh](http://github.com/rodolfojcj/presh) (boolean, `false` by default because it is so experimental)
- `node['prestashop']['presh']['base_url']` - github repository base url to download Presh from (`https://github.com/rodolfojcj/presh/archive/` by default)
- `node['prestashop']['presh']['revision']` - github repository branch, tag or revision of Presh to use (`master` by default, but it also could be something like `c48cdd316d0c32c4f6958ade91b738b12a1c1330`)
- `node['prestashop']['presh']['install_dir_base']` - base name of the directory where Presh will be installed in the node (default is `/usr/local/presh`)
- `node['prestashop']['presh']['install_dir_suffix']` - name suffix of the directory where Presh will be installed in the node (default is the concatenation of a `-` sign and the value of `node.default['prestashop']['presh']['revision']`)
- `node['prestashop']['presh']['keep_updating']` - whether to re-download a possible new version of Presh from the repository (boolean, `true` by default). No matter which value it has, it only will be useful when the revision used is `master`.
- `node['prestashop']['presh']['commands']` - array of Presh commands to execute; each entry is a hash with this convention: `name` is a required key pointing to a Presh command and `params` is an optional key pointing to a string of params expected by that command

Recipes
-------

- `prestashop::default`: main and simple recipe, just invokes the other recipes (conditionally in some cases)
- `prestashop::apache_vhost`: sets the web virtual host and includes some Apache modules
- `prestashop::database`: sets the MySql database for the Prestashop site
- `prestashop::install`: installs Prestashop
- `prestashop::other_modules`: offers the option of getting modules not available in the Prestashop Addons. Only via Git at this moment is supported
- `prestashop::php5_imap`: installs php5 IMAP extension and enables it (only in Debian >= 7.0 or Ubuntu >= 12.10)
- `prestashop::php5_mcrypt`: installs php5 mcrypt extension and enables it (only in Debian >= 7.0 or Ubuntu >= 12.10)
- `prestashop::piwik`: installs Piwik module for Prestashop. It depends on Subversion to get the code from GitHub (it's kind of weird, but it works)
- `prestashop::presh`: installs Presh and applies all the commands present in node['prestashop']['presh']['commands']

Usage
-----

#### prestashop::default
Just include `prestashop` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[prestashop]"
  ]
}
```
When using it from another cookbook, you can override several attributes according to your needs. For example:

```
node.default['prestashop']['db_name'] = 'my_custom_database'
node.default['prestashop']['install_cli_options']['db_name'] = 'my_custom_database'
node.default['prestashop']['install_cli_options']['language'] = 'it'
node.default['prestashop']['install_cli_options']['country'] = 'it'
node.default['prestashop']['install_cli_options']['domain'] = 'www.myotherdomain.com'
node.default['prestashop']['install_cli_options']['name'] = 'MyAwesomeStore'
node.default['prestashop']['version'] = '1.5.6.2'
```

Another example when using it from a wrapper cookbook:

```
node.default['prestashop']['base_dir'] = '/var/www/awesomestore'
node.default['prestashop']['db_server'] = '192.168.1.99'
node.default['prestashop']['db_name'] = 'db_awesome_store'
node.default['prestashop']['db_user'] = 'db_awesome_user'
node.default['prestashop']['db_password'] = 'db_awesome_password'
#
node.default['prestashop']['install_cli_options'] = {
  'domain' => 'www.awesomestore.com',
  'db_user' => 'db_awesome_user',
  'db_password' => 'db_awesome_password',
  'db_name' => 'db_awesome_store',
  'db_prefix' => '',
  'email' => 'theadmin@awesomestore.com',
  'password' => 'TheAdminPassword',
  'name' => 'TheAwesomeStore' # no white spaces
}
#
node.default['prestashop']['vhost_name'] = 'awesomestore'
node.default['prestashop']['domain'] = 'www.awesomestore.com'
#
node.default['prestashop']['use_ssl_with_vhost'] = true
node.default['prestashop']['apache_ssl_params'] = {
  'SSLCertificateFile' => '/etc/ssl/certs/awesomestore.com.crt',
  'SSLCertificateKeyFile' => '/etc/ssl/private/awesomestore.com.key',
  'SSLCACertificateFile' => '/etc/ssl/certs/AlphaSSL-IntermediateCA.crt'
}
#
include_recipe "prestashop::default"
```

When using chef-client executable with an attribute file in JSON format, for
example `chef-client -o 'recipe[prestashop]' -j my-file.json`, such JSON file
could be like this:

```
{
  "prestashop": {
    "base_dir": "/var/www/prestashop1.5",
    "db_name": "ps15_db",
    "install_cli_options": {
      "db_name": "ps15_db"
    },
    "version": "1.5.6.2"
  }
}
```

Notice that right now there is a (needed) redundancy with some attributes
present in the `install_cli_options` hash, like `db_name`. This is because Chef
evaluates the attributes values too early and if not rewritten then some values
could be wrong for this cookbook. This is a point pending for improvement.

Also notice that `db_prefix` option is ignored or is not working as expected,
so some debugging will be needed to make it useful. In the meanwhile the
Prestashop installer will create every table with the `ps_ ` prefix and the
generated `settings.inc.php` config file will contain that `ps_` prefix too.

If you want to use Presh in your own cookbooks take these lines as an example:

```
...
...
node.default['prestashop']['presh']['enabled'] = true # it is false by default
node.default['prestashop']['presh']['revision'] = 'c48cdd316d0c32c4f6958ade91b738b12a1c1330' # 'master' is the default value
node.default['prestashop']['presh']['commands'] = [
  {'name' => 'set_demo_mode', 'params' => '0'},
  {'name' => 'set_friendly_urls', 'params' => '1'},
  {'name' => 'set_debug_settings', 'params' => '0'},
  {'name' => 'optimize_via_ccc', 'params' => '1'},
  {'name' => 'fix_mail'}, # fix TLS problems patching some Prestashop core files
  {'name' => 'set_smtp_mailing', 'params' => 'awesomestore.com mail.awesomestore.com sales@awesomestore.com SalesMailAccountPassword TLS 587'}
]
...
...
include_recipe "prestashop::default"
```

An example including a useful module via Git is to include the awesome [Minic Slider from Minic Studio](http://module.minic.ro/tag/slider/):

```
...
...
node.default['prestashop']['other_modules']['via_git'] = [
  {
    'name' => 'minicslider',
    'url' => 'git://github.com/minicstudio/minicslider.git',
    'rev' => 'master'
  }
]
...
...
include_recipe "prestashop::default"
```

Testing
-------

This cookbok needs automated testing, nothing has been incorporated in this respect.

Contributing
------------

Go to Github, fork it and suggest improvements or submit your issues.

License and Authors
-------------------
Author: Rodolfo Castellanos
