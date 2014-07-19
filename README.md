prestashop Cookbook
===================
Cookbook for installing and configuring Prestashop e-commerce web based solution.

Requirements
------------
#### Packages
The following packages are installed by this cookbook:

- `php5-cli`
- `php5-mysql`
- `tar`
- `wget`
- `unzip`

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

- node`['prestashop']['domain']` - store URL (default 'www.myprestashop.com')
- node`['prestashop']['email']` - store admin email (default 'sells@myprestashop.com')
- node`['prestashop']['password']` - store admin password (default 'V2ryStr4ng_')
- node`['prestashop']['store_name']` - store name (default 'My_Prestashop')
- node`['prestashop']['timezone']` - store timezone (default 'America/Caracas')
- node`['prestashop']['language']` - store main language ISO code (default 'es')
- node`['prestashop']['country']` - store country (default 've')
- node`['prestashop']['newsletter']` - send Prestashop newsletter to admin e-mail (1=yes, 0=no. Default '0')
- node`[prestashop']['install_via_cli']` - do Prestashop installation via CLI (yes/no, default true)
- node`['prestashop']['install_cli_options']` - several options to use when installing via CLI

- node`['prestashop']['translations_url_prefix']` - URL to download several translation files
- node`['prestashop']['translations']` - ISO codes of language tranlations to download and their associated version
- node`['prestashop']['do_cleanup']` - clean several unneeded files (yes/no, default true)
- node`['prestashop']['vhost_name']` - virtual host file name to use when configuring Apache web site
- node`['prestashop']['use_ssl_with_vhost']` - use SSL in virtual host configuration (yes/no, default false)
- node`['prestashop']['apache_ssl_params']` - several SSL params used when configuring Apache virtual host

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
When using from another cookbook, you can override several attributes according to your needs. For example:

```
node.default['prestashop']['db_name'] = 'my_custom_database'
node.default['prestashop']['install_cli_options']['db_name'] = 'my_custom_database'
node.default['prestashop']['install_cli_options']['language'] = 'it'
node.default['prestashop']['install_cli_options']['country'] = 'it'
node.default['prestashop']['install_cli_options']['domain'] = 'www.myotherdomain.com'
node.default['prestashop']['install_cli_options']['name'] = 'MyAwesomeStore'
node.default['prestashop']['version'] = '1.5.6.2'
```

When using chef-client executable with an attribute file in JSON format, for example `chef-client -o 'recipe[prestashop]' -j my-file.json`, such JSON file could be like this:

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

Notice that right now there is a (needed) redundancy with some attributes present in the `install_cli_options` hash, like `db_name`. This is because Chef evaluates the attributes values too early and if not rewriteen then some values could be wrong for this cookbook. This is a point to improve for this cookbook.

Contributing
------------

Go to Github, fork it and suggest improvements

License and Authors
-------------------
Author: Rodolfo Castellanos (rodolfojcj at yahoo.com)
