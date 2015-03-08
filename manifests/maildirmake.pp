define dovecot::maildirmake (
  $directory,
  $user,
) {
  exec { "maildirmake.dovecot-${directory}":
    command => "maildirmake.dovecot ${directory}",
    creates => "${directory}",
    path    => '/bin:/usr/bin',
    user    => "${user}",
    require => Package['dovecot-core'],
  }
}
