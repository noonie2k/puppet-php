define my_php::extension (
  $extension_name    = $name,
  $extension_version = 'latest',
  $repository        = 'pear.php.net',
  $config            = undef,
  $so_config         = undef,
) {

  include ::stdlib
  include ::my_php
  include ::my_php::params
  include ::my_pear

  $extensions_path = $::my_php::params::extensions_path
  $symlinks_path   = $::my_php::params::symlinks_path
  $dc_extension_name = downcase($extension_name)

  ::my_pear::package { $extension_name:
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

  # some extensions dont expect extension=<name>.so in the ini file.
  # this switch allows you to use so_config to workaround that
  if $so_config == undef {
    ::my_php::extension::config { "${dc_extension_name}-config-so":
      file => "${extensions_path}/${dc_extension_name}.ini",
      changes => "set extension ${dc_extension_name}.so",
    }
  } else {
    ::my_php::extension::config { "${dc_extension_name}-config-so":
      file => "${extensions_path}/${dc_extension_name}.ini",
      changes => [ $so_config, 'rm extension' ]
    }
  }

  if is_array($config) {
    ::my_php::extension::config { "${dc_extension_name}-config":
      file => "${extensions_path}/${dc_extension_name}.ini",
      changes => $config,
    }
  }

  Class['my_php'] ->
  Class['my_pear'] ->
  My_pear::Package[$extension_name] ->
  File["${extensions_path}/${dc_extension_name}.ini"] ->
  File["${symlinks_path}/20-${dc_extension_name}.ini"] ->
  My_php::Extension::Config <| |>

}
