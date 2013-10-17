class php::install inherits php {

  package { 'php':
    name   => $package_name,
    ensure => $package_ensure,
  }

}
