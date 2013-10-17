define php::extension (
  $extension_name    = $name,
  $extension_version = 'latest',
  $repository        = 'pear.php.net',
  $config            = undef,
) {

  include ::stdlib
  include ::php
  include ::php::params
  include ::pear

  $extensions_path = $::php::params::extensions_path
  $symlinks_path   = $::php::params::symlinks_path
  $dc_extension_name = downcase($extension_name)

  ::pear::package { $extension_name:
    version => $extension_version,
    repository => $repository,
  }

  # ini file
  file { "${extensions_path}/${dc_extension_name}.ini":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # symlink
  file { "${symlinks_path}/20-${dc_extension_name}.ini":
    ensure => link,
    target => "${extensions_path}/${dc_extension_name}.ini",
    require => File["${extensions_path}/${dc_extension_name}.ini"],
  }

  ::php::extension::config { "${dc_extension_name}-config-so":
    file => "${extensions_path}/${dc_extension_name}.ini",
    changes => "set extension ${dc_extension_name}.so",
  }

  if is_array($config) {
    ::php::extension::config { "${dc_extension_name}-config":
      file => "${extensions_path}/${dc_extension_name}.ini",
      changes => $config,
    }
  }

  Class['php'] ->
  Class['pear'] ->
  Pear::Package[$extension_name] ->
  File["${extensions_path}/${dc_extension_name}.ini"] ->
  File["${symlinks_path}/20-${dc_extension_name}.ini"] ->
  Php::Extension::Config <| |>

}
