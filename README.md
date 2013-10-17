# PHP module 0.1.0

https://github.com/jonono/puppet-php

Jon Billingsley / jonbillingsley@gmail.com

This module installs PHP from your local package provider. It wraps around the PEAR module with the intent of allowing you to configure and install pear/pecl modules in one place (at least, as much as that is even possible). It also allows ini configuration via Augeas.

## Requires:

puppetlabs/stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
treehouseagency/pear - https://github.com/treehouseagency/puppet-pear

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
        'stanza' => 'session',
        'changes' => [ 'set session.something 1',
                       'set session.somethingelse 999',
                     ],
      },
    },
  }

### Install and configure a pecl extension

  php::extension { 'APC':
    repository   => 'pecl.php.net',
    config       => [ 'set apc.enabled 1' ],
  }

## Justifications, Rationalizations, Caveats, etc
I realize this could obviously be a lot cleaner. Especially the "ini_changes" parameters. Because of the way php ini files are stanza'd, changing multiple lines in multiple stanzas requires multiple augeas {} resources because the config parameters will live in different contexts. I'm doing a create_resources with that hash which is why it looks the way it does.

I could have also gone the template route but I dislike working with templates. Augeas is gross at times but I prefer it. The (major) downside of this is you need to understand how Augeas works to use this module because it doesn't hide its underpinnings very well. I might add a template option later on, we'll see.

The php::extension define doesn't handle prerequisites. Make sure you know what you're doing - the PEAR package provider isn't very good about telling you when a pecl module failed to install because some lib was missing (I think this might be a problem with pecl/pear itself but I can't remember anymore).

Lastly - I have only tested this on Ubuntu 12.04 with Puppet 3+. If you're testing on Puppetlabs' vagrant boxes, be careful because they're still using the Puppet gem instead of the .deb from their own apt repo, and augeas won't work until you turf that gem and install Puppet properly.

## TODO
* aforementioned template support for php.ini files
* make those spec/tests directories not just for show
