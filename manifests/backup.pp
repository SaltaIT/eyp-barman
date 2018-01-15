define barman::backup (
                        $description,
                        $host,
                        $backupname                  = $name,
                        $retention_policy_mode       = 'auto',
                        $recovery_window_days        = '30',
                        $user                        = 'postgres',
                        $port                        = '5432',
                        $use_notificationscript      = true,
                        # notification script
                        $notification_ensure         = 'present',
                        $logdir                      = '/var/log/pgbarmanbackup',
                        $mailto                      = undef,
                        $retention                   = '15',
                        $idhost                      = undef,
                        $compress_barmanlogfile      = true,
                        $notificationscript_basedir  = '/usr/local/bin',
                        $backup_type                 = 'pgBarman', # @param backup_type Backup ID for barman backups (default: pgBarman)
                        # cron
                        $cron_ensure                 = 'present', # @param cron_ensure Whether the cronjob should be present or not. (default: present)
                        $hour_notificationscript     = '2',
                        $minute_notificationscript   = '0',
                        $month_notificationscript    = undef,
                        $monthday_notificationscript = undef,
                        $weekday_notificationscript  = undef,
                        $setcron_notificationscript  = true,
                        $export_full_s3              = undef,
                        $export_full_disk            = undef,
                        $export_full_tmpdir          = '/var/lib/export_barman',
                        $export_retention            = '1',
                      ) {
  include ::barman

  file { "${barman::config::barmanconfigdir}/${backupname}.conf":
    ensure  => 'present',
    owner   => $barman::params::barmanuser,
    group   => $barman::params::barmangroup,
    mode    => '0644',
    notify  => Class['barman::service'],
    require => Class['barman::config'],
    content => template("${module_name}/backup.erb"),
  }

  if($export_full_s3!=undef or $export_full_disk!=undef)
  {
    if(!defined(File["${notificationscript_basedir}/exportfullbarman.sh"]))
    {
      file { "${notificationscript_basedir}/exportfullbarman.sh":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        content => file("${module_name}/exportfull/exportfullbarman.sh"),
      }
    }

    file { "${notificationscript_basedir}/exportfullbarman_${backupname}.config":
      ensure  => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template("${module_name}/exportfull/exportfullconfig.erb"),
    }

    $export_action = "${notificationscript_basedir}/exportfullbarman.sh ${notificationscript_basedir}/exportfullbarman_${backupname}.config"

    if($export_full_disk!=undef)
    {
      $exportdir = $export_full_disk
    }
    else
    {
      $exportdir = $export_full_tmpdir
    }
  }

  if($use_notificationscript)
  {
    file { "${notificationscript_basedir}/pgbarmanbackup_${backupname}.sh":
      ensure  => $notification_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      require => File["${barman::config::barmanconfigdir}/${backupname}.conf"],
      content => file("${module_name}/backupscript/barmanbackup.sh"),
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
      cron { "cronjob barman ${backupname}":
        ensure   => $cron_ensure,
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
  }
}
