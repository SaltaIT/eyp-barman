define barman::backup (
                        $description,
                        $host,
                        $backupname=$name,
                        $retention_policy_mode='auto',
                        $recovery_window_days=30,
                        $user='postgres',
                        $use_notificationscript=true,
                        #notification script
                        $notification_ensure='present',
                        $logdir=undef,
                        $mailto=undef,
                        $retention='15',
                        $idhost=undef,
                        $compress_barmanlogfile=true,
                        $notificationscript_basedir='/usr/local/bin',
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
    file { "${notificationscript_basedir}/pgbarmanbackup.${backupname}.sh":
      file    => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      require => File["${barman::config::barmanconfigdir}/${backupname}.conf"],
      content => template("${module_name}/backupscript/barmanbackup.erb"),
    }

    file { "${notificationscript_basedir}/pgbarmanbackup.${backupname}.config":
      file    => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      require => File["${notificationscript_basedir}/pgbarmanbackup.${backupname}.sh"],
      content => template("${module_name}/backupscript/barmanbackupconfig.erb"),
    }


  }
  else {
    fail(' - Not implemented - ')
  }

}
