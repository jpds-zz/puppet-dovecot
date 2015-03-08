define dovecot::maildirmake (
  $directory,
  $user,
) {
  exec { "maildirmake.dovecot-${directory}":
    command => "maildirmake.dovecot ${directory} && maildirmake.dovecot ${directory}/.Drafts && maildirmake.dovecot ${directory}/.Sent && maildirmake.dovecot ${directory}/.Trash && maildirmake.dovecot ${directory}/.Templates",
    creates => "${directory}",
    path    => '/bin:/usr/bin',
    user    => "${user}",
    require => Package['dovecot-core'],
  }
}
