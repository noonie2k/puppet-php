define php::config($file, $stanza, $changes) {

  augeas { "${file}-${name}":
    context => "/files${file}/${stanza}",
    changes => $changes,
  }

}
