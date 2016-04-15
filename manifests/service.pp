class barman::service (
                      ) inherits barman::params {
  #service or exec here
  #/usr/bin/barman cron
  cron { 'barman cron':
    ensure   => 'present',
    command  => '/usr/bin/barman cron',
    user     => 'root',
    hour     => '*',
    minute   => '*',
    month    => '*',
    monthday => '*',
    weekday  => '*',
  }
}
