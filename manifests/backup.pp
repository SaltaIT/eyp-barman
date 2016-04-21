define barman::backup (
                        $description,
                        $host,
                        $backupname=$name,
                        $retention_policy_mode='auto',
                        $recovery_window_days=30,
                        $user='postgres',
                        $use_notificationscript=true,
                        #notification script
                        $logdir=undef,
                        $mailto=undef,
                        $retention='15',
                        $idhost=undef,
                        $compress_barmanlogfile=true,
                      ) {
  #
  file { "${barman::config::barmanconfigdir}/${backupname}.conf":
    ensure  => 'present',
    owner   => $barman::params::barmanuser,
    group   => $barman::params::barmangroup,
    mode    => '0644',
    notify  => Class['barman::service'],
    require => Class['barman::config'],
    content => template("${module_name}/backup.erb"),
  }

  if($use_notificationscript)
  {
    #TODO

  }
  else {
    fail(' - Not implemented - ')
  }

}
