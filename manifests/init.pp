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
  $dump_script_template            = params_lookup('dump_script_template'),
  $dump_script_path                = params_lookup('dump_script_path'),
  $check_script_template           = params_lookup('check_script_template'),
  $check_script_path               = params_lookup('check_script_path'),
  $restore_script_template         = params_lookup('restore_script_template'),
  $restore_script_path             = params_lookup('restore_script_path'),
  $backup_dir                      = params_lookup('backup_dir'),
  $postgresql_client_package_name  = params_lookup('postgresql_client_package_name'),
  $grep_package_name               = params_lookup('grep_package_name'),
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
