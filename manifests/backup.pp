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
                        #cron
                        $hour_notificationscript='2',
                        $minute_notificationscript='0',
                        $month_notificationscript=undef,
                        $monthday_notificationscript=undef,
                        $weekday_notificationscript=undef,
                        $setcron_notificationscript=true,
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
    file { "${notificationscript_basedir}/pgbarmanbackup_${backupname}.sh":
      ensure  => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      require => File["${barman::config::barmanconfigdir}/${backupname}.conf"],
      content => template("${module_name}/backupscript/barmanbackup.erb"),
    }

    file { "${notificationscript_basedir}/pgbarmanbackup_${backupname}.config":
      ensure  => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      require => File["${notificationscript_basedir}/pgbarmanbackup_${backupname}.sh"],
      content => template("${module_name}/backupscript/barmanbackupconfig.erb"),
    }

    if($setcron_notificationscript)
    {
      cron { "cronjob mysqldump ${name}":
        command  => "${notificationscript_basedir}/pgbarmanbackup_${backupname}.sh",
        user     => 'root',
        hour     => $hour_notificationscript,
        minute   => $minute_notificationscript,
        month    => $month_notificationscript,
        monthday => $monthday_notificationscript,
        weekday  => $weekday_notificationscript,
        require  => File[ [ "${notificationscript_basedir}/pgbarmanbackup_${backupname}.config",
                            "${notificationscript_basedir}/pgbarmanbackup_${backupname}.sh"
                        ] ],
    }


  }
  else {
    fail(' - Not implemented - ')
  }

}
