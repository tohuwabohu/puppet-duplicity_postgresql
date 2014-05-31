#duplicity_postgresql

##Overview

Backup and restore PostgreSQL databases based on duplicity. The modules makes sure a database dump is include in the
referenced duplicity backup and restores this previously taken dump in case the existing database is empty.

##Usage

Make sure, the parent backup directory (`/var/backups`) is properly existing:

```
file { '/var/backups':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}
```

Now you're ready to manage a database:

```
duplicity_postgresql::database { 'my-database':
  profile => 'system',
}
```

This will create a dump of the PostgreSQL database `my-database` each time the backup profile `system` is run. The dump
will be keep in the default backup directory. If the database is existing but empty, the dump will be restored. In case
the dump file is missing, Puppet will attempt to restore the file from the last backup.

If you just want to backup the database but don't restore it, set the `ensure` parameter to `backup`:

```
duplicity_postgresql::database { 'my-database':
  ensure  => backup,
  profile => 'system',
}
```

##Limitations

The module has been tested on the following operating systems. Testing and patches for other platforms are welcome.

* Debian Linux 6.0 (Squeeze)

[![Build Status](https://travis-ci.org/tohuwabohu/tohuwabohu-duplicity_postgresql.png?branch=master)](https://travis-ci.org/tohuwabohu/tohuwabohu-duplicity_postgresql)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
