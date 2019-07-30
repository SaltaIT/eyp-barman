include ::epel

class { 'postgresql':
  wal_level         => 'hot_standby',
  max_wal_senders   => '3',
  wal_keep_segments => '8',
  version           => '10',
  archive_mode      => true,
  archive_dir       => '/var/lib/barman/pgm/incoming',
  archive_dir_mode  => '0666',
  archive_dir_chmod => '0666',
}

->

class { 'barman':
  require => Class['::epel'],
}

barman::backup { 'pgm':
  description => 'postgres master',
  host        => '192.168.56.29',
  port        => '60901',
  mailto      => 'backup_reports@systemadmin.es',
}
