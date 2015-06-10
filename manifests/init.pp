# Class: my_php
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
class my_php (
  $package_name       = $::my_php::params::package_name,
  $package_ensure     = $::my_php::params::package_ensure,
  $extensions_path    = $::my_php::params::extensions_path,
  $symlinks_path      = $::my_php::params::symlinks_path,
  $apache_ini_path    = $::my_php::params::apache_ini_path,
  $cli_ini_path       = $::my_php::params::cli_ini_path,
  $apache_ini_changes = undef,
  $cli_ini_changes    = undef,
) inherits ::my_php::params {

  include ::stdlib
  include ::my_php::install

  if is_hash($apache_ini_changes) {
    create_resources(::my_php::config, $apache_ini_changes, { file => $apache_ini_path })
  }
  if is_hash($cli_ini_changes) {
    create_resources(::my_php::config, $cli_ini_changes, { file => $cli_ini_path })
  }

  anchor{ '::my_php::begin': } ->
  Class['::my_php::install'] ->
  anchor{ '::my_php::end': }

}
