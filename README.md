# PHP module

https://github.com/jonono/puppet-php

Jon Billingsley / jonbillingsley@gmail.com

This module installs PHP from your local package provider. It wraps around the PEAR module with the intent of allowing you to configure and install pear/pecl modules in one place (at least, as much as that is even possible). It also allows ini configuration via Augeas.

## Requires:

* puppetlabs/stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
* treehouseagency/pear - https://github.com/treehouseagency/puppet-pear

## Examples

### Install php

    class { 'php': }

### Install php and friends

    class { 'php':
      package_name   => [ 'php5', 'php5-mysql', 'php5-memcached' ],
      package_ensure => latest,
    }

### Install php and modify its apache php.ini in some way

    class { 'php':
      apache_ini_changes => {
        'apache-session-stanza-changes' => {
          'stanza'  => 'session',
          'changes' => [ 'set session.something 1',
                         'set session.somethingelse 999',
                       ],
        },
      },
    }

### Install and configure a pecl extension

    php::extension { 'APC':
      repository => 'pecl.php.net',
      config     => [ 'set apc.enabled 1' ],
    }

### Install and configure a zendextension (for example)

    php::extension { 'zendopcache':
      repository => 'pecl.php.net',
      so_config  => 'set zend_extension /usr/lib/php5/20100525/opcache.so'
    }

### Warning

This module is not very good and desperately needs a rewrite. Use at your own risk.
