# Dovecot ssl class.
class dovecot::ssl(
  $enable_ssl      = false,
  $ssl_protocols   = '',
) inherits dovecot::params {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['dovecot']) {
    fail('You must include the dovecot base class before using any dovecot defined resources')
  }

  validate_bool($enable_ssl)

  file { "${dovecot::params::dovecot_conf_d}/10-ssl.conf":
    ensure  => present,
    content => template('dovecot/10-ssl.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Class['Dovecot::Service'],
  }
}

