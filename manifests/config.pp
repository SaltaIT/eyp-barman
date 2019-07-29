class barman::config inherits barman {

  file { $barman::barmanhome:
    ensure => 'directory',
    owner  => $barman::barmanhome_username,
    group  => $barman::barmanhome_group,
    mode   => $barman::barmanhome_mode,
  }

  file { $barman::barmanconfigdir:
    ensure  => 'directory',
    owner   => $barman::barmanconfigdir_username,
    group   => $barman::barmanconfigdir_group,
    mode    => $barman::barmanconfigdir_mode,
    recurse => $barman::barmanconfigdir_recurse,
    purge   => $barman::barmanconfigdir_purge,
    require => Package[$barman::params::barman_package],
  }

  file { $barman::barmanconfigfile:
    ensure  => 'present',
    owner   => $barman::barmanconfigfile_username,
    group   => $barman::barmanconfigfile_group,
    mode    => $barman::barmanconfigfile_mode,
    content => template("${module_name}/barmanconf.erb"),
    require => Package[$barman::params::barman_package],
  }

}
