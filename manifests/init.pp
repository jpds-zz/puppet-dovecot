# Default Dovecot class.
class dovecot(
  $package_core   = $dovecot::params::package_core,
  $package_imapd  = $dovecot::params::package_imapd,
  $service_name   = $dovecot::params::service,
  $enable_imap    = $dovecot::params::enable_imap,
  $protocols      = $dovecot::params::protocols,
  $login_greeting = 'Dovecot ready.',
) inherits dovecot::params {
  package { $package_core:
    ensure => installed,
    before => File['dovecot_dir'],
  }

  if $enable_imap == true {
    package { $package_imapd:
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
}

