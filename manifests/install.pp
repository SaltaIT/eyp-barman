class barman::install (
                        $sshkey_type,
                        $sshkey_key,
                      ) inherits barman::params {

  package { $barman::params::barman_package:
    require => $barman::params::barman_package_require,
  }

  sshkey { 'barman-key':
    type => $sshkey_type,
    key  => $sshkey_key,
  }

}
