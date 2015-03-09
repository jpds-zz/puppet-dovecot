# Default Dovecot class.
class dovecot(
  $package_core       = $dovecot::params::package_core,
  $package_imapd      = $dovecot::params::package_imapd,
  $package_pop3d      = $dovecot::params::package_pop3d,
  $service_name       = $dovecot::params::service,
  $enable_imap        = $dovecot::params::enable_imap,
  $enable_pop3        = $dovecot::params::enable_pop3,
  $protocols          = $dovecot::params::protocols,
  $imap_process_limit = '1024',
  $login_greeting     = 'Dovecot ready.',
) inherits dovecot::params {
  package { $package_core:
    ensure => installed,
    before => File['dovecot_dir'],
  }

  validate_bool($enable_imap)
  validate_bool($enable_pop3)

  if $enable_imap == true and $::osfamily == 'Debian' {
    package { $package_imapd:
      ensure => installed,
    }
  }

  if $enable_pop3 == true and $::osfamily == 'Debian' {
    package { $package_pop3d:
      ensure => installed,
    }
  }

  class { '::dovecot::service':
    service_name => $service_name,
  }

  file { 'dovecot_dir':
    ensure => directory,
    path   => $dovecot::params::dovecot_dir,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file {  $dovecot::params::dovecot_conf:
    ensure  => present,
    content => template('dovecot/dovecot.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_core],
    notify  => Class['Dovecot::Service'],
  }

  file { 'dovecot_conf_dir':
    ensure => directory,
    path   => $dovecot::params::dovecot_conf_d,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "${dovecot::params::dovecot_conf_d}/10-master.conf":
    ensure  => present,
    content => template('dovecot/10-master.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Class['Dovecot::Service'],
  }
}

