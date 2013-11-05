class php::install inherits php {

  package { $package_name:
    ensure => $package_ensure,
  }

}
