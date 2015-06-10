class my_php::install inherits my_php {

  package { $package_name:
    ensure => $package_ensure,
  }

}
