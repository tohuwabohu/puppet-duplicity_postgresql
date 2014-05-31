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
# [*backup_dir*]
#   Set the directory where to store the backup dump files.
#
# [*client_package_name*]
#   Set the name of the package which contains the pg_dump utility.
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
  $dump_script_template            = params_lookup('dump_script_template'),
  $dump_script_path                = params_lookup('dump_script_path'),
  $backup_dir                      = params_lookup('backup_dir'),
  $postgresql_client_package_name  = params_lookup('postgresql_client_package_name'),
  $gzip_package_name               = params_lookup('gzip_package_name'),
) inherits duplicity_postgresql::params {

  if empty($dump_script_template) {
    fail('Class[Duplicity_Postgresql]: dump_script_template must not be empty')
  }
  validate_absolute_path($dump_script_path)
  validate_absolute_path($backup_dir)
  if empty($postgresql_client_package_name) {
    fail('Class[Duplicity_Postgresql]: postgresql_client_package_name must not be empty')
  }
  if empty($gzip_package_name) {
    fail('Class[Duplicity_Postgresql]: gzip_package_name must not be empty')
  }

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
}
