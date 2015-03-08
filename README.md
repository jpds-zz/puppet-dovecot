# puppet-dovecot

This Puppet module contains configurations for Dovecot.

## Build status

[![Build Status](https://travis-ci.org/jpds/puppet-dovecot.svg?branch=master)](https://travis-ci.org/jpds/puppet-dovecot)

## Example usage

The core Dovecot package can be installed by simply doing:

```puppet
include dovecot
```

## Enabling IMAP

IMAP support can be installed by doing:

```puppet
class { 'dovecot':
  enable_imap    => true,
  protocols      => 'imap',
  login_greeting => 'Dovecot ready.',
}
```

## Enabling the auth service

Should one wish to use Dovecot as an external auth service, for say, Postfix,
this can be done with:

```puppet
class { 'dovecot::auth':
  service_auth => true,
}
```

## Enabling SSL

SSL parameters can be configured using the *dovecot::ssl* class as follows:

```puppet
class { 'dovecot::ssl':
  enable_ssl      => true,
  ssl_cert        => '</etc/dovecot/dovecot.pem',
  ssl_protocols   => '!SSLv3 !SSLv2',
  ssl_key         => '</etc/dovecot/private/dovecot.pem',
}
```

## Creating Maildir directories

Maildir directories can be created using this module. For example, on a
system-wide skel level:

```puppet
dovecot::maildirmake { 'skel-maildir':
  directory => "/etc/skel/Maildir",
  user      => "root",
}
```

Or for a single user:


```puppet
dovecot::maildirmake { 'user-maildir':
  directory => "/home/user/Maildir",
  user      => "user",
}
```

## License

See [LICENSE](LICENSE) file.

