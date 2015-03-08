# Default Dovecot class.
class dovecot(
  $package_name = $dovecot::params::package,
  $service_name = $dovecot::params::service,
  $enable_imap  = $dovecot::params::enable_imap,
  $protocols    = $dovecot::params::protocols,
) inherits dovecot::params {
  package { $package_name:
    ensure => installed,
    before => File['dovecot_dir'],
  }

  if $enable_imap == true {
    package { 'dovecot-imapd':
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
    require => Package[$package_name],
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

