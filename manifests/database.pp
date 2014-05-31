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
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity_postgresql::database(
  $ensure = present,
  $database = $title,
  $profile = 'backup',
) {
  require duplicity_postgresql

  if $ensure !~ /^present|backup|absent$/ {
    fail("Duplicity_Postgresql::Database[${title}]: ensure must be either present, backup or absent, got '${ensure}'")
  }
  if $ensure =~ /^present|backup$/ and empty($profile) {
    fail("Duplicity_Postgresql::Database[${title}]: profile must not be empty")
  }

  $dump_script_path = $duplicity_postgresql::dump_script_path
  $dump_file = "${duplicity_postgresql::backup_dir}/${database}.sql.gz"
  $exec_before_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }

  duplicity::profile_exec_before { "${profile}/postgresql/${database}":
    ensure  => $exec_before_ensure,
    profile => $profile,
    content => "${dump_script_path} ${database}",
    order   => '10',
  }

  duplicity::file { $dump_file:
    ensure  => $ensure,
    profile => $profile
  }
}
