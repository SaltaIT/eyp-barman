class barman::install (
                        $sshkey_type = undef,
                        $sshkey_key  = undef,
                      ) inherits barman::params {

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

  package { $barman::params::barman_package:
    require => $barman::params::barman_package_require,
  }

  if($sshkey_type!=undef and $sshkey_key!=undef)
  {
    ssh_authorized_key { 'barman-key':
      user    => $barman::params::barmanuser,
      type    => $sshkey_type,
      key     => $sshkey_key,
      require => Package[$barman::params::barman_package],
    }
  }
}
