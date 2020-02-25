class barman::nagios(
                      $basedir        = '/usr/local/bin',
                      $add_nrpe_sudos = true,
                    ) inherits barman::params {
  include ::barman

  file { "${basedir}/check_barman_backups_failed":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => file("${module_name}/nagios/check_barman_backups_failed.sh"),
  }

  if($add_nrpe_sudos)
  {
    nrpe::sudo { 'sudo NRPE check_barman_backups_failed':
      command => "${basedir}/check_barman_backups_failed",
    }
  }
}
