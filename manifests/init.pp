# == Class: duplicity_postgresql
#
# Manage scripts to backup and restore PostgreSQL databases.
#
# === Parameters
#
# [*dump_script_template*]
#   Set the template to be used when creating the dump script.
#
# [*dump_script_path*]
#   Set the path where to write the script to.
#
# [*check_script_template*]
#   Set the template to be used when creating the check script.
#
# [*check_script_path*]
#   Set the path where to write the check script to.
#
# [*restore_script_template*]
#   Set the template to be used when creating the restore script.
#
# [*restore_script_path*]
#   Set the path where to write the restore script to.
#
# [*backup_dir*]
#   Set the directory where to store the backup dump files.
#
# [*postgresql_client_package_name*]
#   Set the name of the package which contains the pg_dump utility.
#
# [*grep_package_name*]
#   Set the name of the package which contains the grep utility.
#
# [*gzip_package_name*]
#   Set the name of the package which contains the gzip utility.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity_postgresql(
  String $dump_script_template = $duplicity_postgresql::params::dump_script_template,
  Stdlib::Absolutepath $dump_script_path = $duplicity_postgresql::params::dump_script_path,
  String $check_script_template = $duplicity_postgresql::params::check_script_template,
  Stdlib::Absolutepath $check_script_path = $duplicity_postgresql::params::check_script_path,
  String $restore_script_template = $duplicity_postgresql::params::restore_script_template,
  Stdlib::Absolutepath $restore_script_path = $duplicity_postgresql::params::restore_script_path,
  Stdlib::Absolutepath $backup_dir = $duplicity_postgresql::params::backup_dir,
  String $postgresql_client_package_name = $duplicity_postgresql::params::postgresql_client_package_name,
  String $grep_package_name = $duplicity_postgresql::params::grep_package_name,
  String $gzip_package_name = $duplicity_postgresql::params::gzip_package_name,
) inherits duplicity_postgresql::params {
  file { $backup_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { $dump_script_path:
    ensure  => file,
    content => template($dump_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$backup_dir],
      Package[$postgresql_client_package_name],
      Package[$gzip_package_name],
    ]
  }

  file { $check_script_path:
    ensure  => file,
    content => template($check_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      Package[$postgresql_client_package_name],
      Package[$grep_package_name],
    ]
  }

  file { $restore_script_path:
    ensure  => file,
    content => template($restore_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$backup_dir],
      Package[$postgresql_client_package_name],
      Package[$gzip_package_name],
    ]
  }
}
