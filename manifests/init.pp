# Class: php
#
# This class installs php from your friendly local package provider.
# It also manages ini file config via Augeas and wraps the pear module
# to allow easier pecl/pear module management.
#
# REQUIRES:
# puppetlabs/stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
# treehouseagency/pear - https://github.com/treehouseagency/puppet-pear
#
# See README.md for more.
#
class php (
  $package_name       = $::php::params::package_name,
  $package_ensure     = $::php::params::package_ensure,
  $extensions_path    = $::php::params::extensions_path,
  $symlinks_path      = $::php::params::symlinks_path,
  $apache_ini_path    = $::php::params::apache_ini_path,
  $cli_ini_path       = $::php::params::cli_ini_path,
  $apache_ini_changes = undef,
  $cli_ini_changes    = undef,
) inherits ::php::params {

  include ::stdlib
  include ::php::install

  if is_hash($apache_ini_changes) {
    create_resources(::php::config, $apache_ini_changes, { file => $apache_ini_path })
  }
  if is_hash($cli_ini_changes) {
    create_resources(::php::config, $cli_ini_changes, { file => $cli_ini_path })
  }

  anchor{ '::php::begin': } ->
  Class['::php::install'] ->
  anchor{ '::php::end': }

}
