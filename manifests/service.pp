# Dovecot service management.
class dovecot::service(
  $service_name   = $::dovecot::params::service,
) {
  service { $service_name:
    ensure     => running,
    enable     => true,
    require    => Class['dovecot'],
  }
}
