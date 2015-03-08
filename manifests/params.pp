# Default Dovecot parameters.
class dovecot::params {
  case $::osfamily {
    'Debian': {
      $package_core  = 'dovecot-core'
      $package_imapd = 'dovecot-imapd'
      $package_pop3d = 'dovecot-pop3d'
    }

    'RedHat': {
      $package_core  = 'dovecot'
      $package_imapd = 'dovecot'
      $package_pop3d = 'dovecot'
    }

    default: {
      fail("${::osfamily} is not supported.")
    }
  }

  $service         = 'dovecot'
  $dovecot_dir     = '/etc/dovecot'
  $dovecot_conf    = '/etc/dovecot/dovecot.conf'
  $dovecot_conf_d  = '/etc/dovecot/conf.d'
  $enable_imap     = false
  $enable_pop3     = false
  $protocols       = ''
}
