define php::extension::config($file, $changes) {

  augeas { "$file-$name":
    context => "/files$file/.anon",
    changes => $changes,
  }

}
