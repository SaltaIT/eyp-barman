class barman::install (
                        $sshkey_type = undef,
                        $sshkey_key  = undef,
                      ) inherits barman::params {

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
