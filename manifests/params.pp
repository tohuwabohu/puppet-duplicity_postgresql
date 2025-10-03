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
  $backup_dir = $facts['os']['family'] ? {
    default => '/var/backups/postgresql'
  }

  $dump_script_template = 'duplicity_postgresql/usr/local/sbin/dump-postgresql-database.sh.erb'
  $dump_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/dump-postgresql-database.sh'
  }

  $check_script_template = 'duplicity_postgresql/usr/local/sbin/check-postgresql-database.sh.erb'
  $check_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/check-postgresql-database.sh'
  }

  $restore_script_template = 'duplicity_postgresql/usr/local/sbin/restore-postgresql-database.sh.erb'
  $restore_script_path = $facts['os']['family'] ? {
    default => '/usr/local/sbin/restore-postgresql-database.sh'
  }

  $postgresql_client_package_name = $facts['os']['family'] ? {
    default => 'postgresql-client'
  }
  $grep_package_name = $facts['os']['family'] ? {
    default => 'grep'
  }
  $gzip_package_name = $facts['os']['family'] ? {
    default => 'gzip'
  }
}
