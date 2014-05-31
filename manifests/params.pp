# == Class: duplicity_postgresql::params
#
# Default values of the duplicity_postgresql class.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity_postgresql::params {
  $backup_dir = $::osfamily ? {
    default => '/var/backups/postgresql'
  }

  $dump_script_template = 'duplicity_postgresql/usr/local/sbin/dump-postgresql-database.sh.erb'
  $dump_script_path = $::osfamily ? {
    default => '/usr/local/sbin/dump-postgresql-database.sh'
  }

  $postgresql_client_package_name = $::osfamily ? {
    default => 'postgresql-client'
  }
  $gzip_package_name = $::osfamily ? {
    default => 'gzip'
  }
}
