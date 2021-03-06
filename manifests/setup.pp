# == Class: duplicity::setup
#
# Complete the installation.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::setup inherits duplicity {
  include duplicity::params

  file { $duplicity::params::duply_config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    backup  => false,
    purge   => true,
    force   => true,
    recurse => true,
  }

  file { $duplicity::params::duply_key_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    backup  => false,
    purge   => true,
    force   => true,
    recurse => true,
  }

  file { $duplicity::params::duply_public_key_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $duplicity::params::duply_private_key_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { $duplicity::duply_log_dir:
    ensure => directory,
    owner  => 'root',
    group  => $duplicity::duply_log_group,
    mode   => '0640',
  }

  logrotate::rule { 'duply':
    ensure       => present,
    path         => "${duplicity::duply_log_dir}/*.log",
    rotate       => 5,
    size         => '100k',
    compress     => true,
    missingok    => true,
    create       => true,
    create_owner => 'root',
    create_group => $duplicity::duply_log_group,
    create_mode  => '0640',
    require      => File[$duplicity::duply_log_dir],
  }
}
