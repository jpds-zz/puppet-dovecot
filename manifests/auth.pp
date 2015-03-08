# Dovecot auth class.
class dovecot::auth(
  $service_auth      = false,
  $service_auth_port = '12345',
) inherits dovecot::params {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['dovecot']) {
    fail('You must include the dovecot base class before using any dovecot defined resources')
  }

  validate_bool($service_auth)

  file { "${dovecot::params::dovecot_conf_d}/10-auth.conf":
    ensure  => present,
    content => template('dovecot/10-auth.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    notify  => Class['Dovecot::Service'],
  }
}

