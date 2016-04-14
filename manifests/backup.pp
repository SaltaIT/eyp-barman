define barman::backup (
                        $description,
                        $host,
                        $backupname=$name,
                        $retention_policy_mode='auto',
                        $recovery_window_days=30,
                        $user='postgres',

                      ) {
  #
  file { "${barman::config::barmanconfigdir}/${backupname}.conf":
    ensure  => 'present',
    owner   => $barman::params::barmanuser,
    group   => $barman::params::barmangroup,
    mode    => '0644',
    notify  => Class['barman::service'],
    require => Class['barman::config']
  }

}
