
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename = 'barman'
  $barmanconf = '/etc/barman/barman.conf'
  $barmanpgm = '/etc/barman.d/pgm.conf'

when 'Debian'
  $packagename = 'barman'
  $barmanconf = '/etc/barman/barman.conf'
  $barmanpgm = '/etc/barman.d/pgm.conf'

else
  $examplevar = '-_-'

end
