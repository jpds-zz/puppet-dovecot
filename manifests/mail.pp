# Dovecot mail class.
class dovecot::mail(
  $mail_location   = 'mbox:~/mail:INBOX=/var/mail/%u',
) inherits dovecot::params {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['dovecot']) {
    fail('You must include the dovecot base class before using any dovecot defined resources')
  }

  file { "${dovecot::params::dovecot_conf_d}/10-mail.conf":
    ensure  => present,
    content => template('dovecot/10-mail.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Class['Dovecot::Service'],
  }
}

