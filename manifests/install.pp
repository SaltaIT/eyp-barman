class barman::install inherits barman {

  if($barman::manage_package)
  {
    if($barman::params::rsync_package!=undef)
    {
      if(!defined(Package[$barman::params::rsync_package]))
      {
        package { $barman::params::rsync_package:
          ensure => 'installed',
          before => Package[$barman::params::barman_package],
        }
      }
    }

    if($barman::params::include_epel)
    {
      include ::epel

      Package[$barman::params::barman_package] {
        require => Class['::epel'],
      }
    }

    package { $barman::params::barman_package:
      ensure => $barman::package_ensure,
    }
  }

  if($barman::sshkey_type!=undef and $barman::sshkey_key!=undef)
  {
    ssh_authorized_key { 'barman-key':
      user    => $barman::params::barmanuser,
      type    => $barman::sshkey_type,
      key     => $barman::sshkey_key,
      require => Package[$barman::params::barman_package],
    }
  }
}
