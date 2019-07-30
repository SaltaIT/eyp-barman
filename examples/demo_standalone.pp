class { 'barman':
}

barman::backup { 'pgm':
  description => 'postgres master',
  host        => '127.0.0.1',
  port        => '5432',
  mailto      => 'backup_reports@systemadmin.es',
}
