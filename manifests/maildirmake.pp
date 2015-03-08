define dovecot::maildirmake (
  $directory,
  $user,
) {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['dovecot']) {
    fail('You must include the dovecot base class before using any dovecot defined resources')
  }

  exec { "maildirmake.dovecot-${directory}":
    command => "maildirmake.dovecot ${directory} && maildirmake.dovecot ${directory}/.Drafts && maildirmake.dovecot ${directory}/.Sent && maildirmake.dovecot ${directory}/.Trash && maildirmake.dovecot ${directory}/.Templates",
    creates => $directory,
    path    => '/bin:/usr/bin',
    user    => $user,
    require => Package[$dovecot::params::package_core],
  }
}
