# == Define: duplicity_postgresql::database
#
# Backup and optionally restore PostgreSQL databases using duplicity.
#
# === Parameters
#
# [*ensure*]
#   Set state the package should be in. Can be either present (= backup and restore if not existing), backup (= backup
#   only), or absent.
#
# [*database*]
#   Set the name of the database.
#
# [*profile*]
#   Set the name of the duplicity profile where the database dump file is included in.
#
# [*timeout*]
#   Set the maximum time each restore should take: the restore of the database dump and the import into the database.
#   If one operation takes longer than the timeout, it is considered to #   have failed and will be stopped. The
#   timeout is specified in seconds. The default timeout is 300 seconds and you can set it to 0 to disable the timeout.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity_postgresql::database(
  Enum[present,backup,absent] $ensure = present,
  String $database = $title,
  String $profile = 'system',
  Integer $timeout  = 300,
) {
  require duplicity_postgresql

  $dump_file = "${duplicity_postgresql::backup_dir}/${database}.sql.gz"
  $exec_before_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }

  duplicity::profile_exec_before { "${profile}/postgresql/${database}":
    ensure  => $exec_before_ensure,
    profile => $profile,
    content => "${duplicity_postgresql::dump_script_path} ${database}",
    order   => '10',
  }

  duplicity::file { $dump_file:
    ensure  => $ensure,
    profile => $profile,
    timeout => $timeout,
  }

  if $ensure == present {
    exec { "${duplicity_postgresql::restore_script_path} ${database}":
      onlyif  => "${duplicity_postgresql::check_script_path} ${database}",
      timeout => $timeout,
      require => [
        Duplicity::File[$dump_file],
        File[$duplicity_postgresql::check_script_path],
        File[$duplicity_postgresql::restore_script_path],
      ],
    }
  }
}
