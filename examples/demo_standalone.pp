class { 'barman':
}

barman::backup { 'pgm':
  description => 'postgres master',
  host        => '192.168.56.29',
  port        => '60901',
  mailto      => 'backup_reports@systemadmin.es',
}
