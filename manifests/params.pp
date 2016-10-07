class barman::params {

  $postgres_port_default='5432'
  #fer 9.2 minim

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^6.*$/:
        {
          $barman_package='barman'
          $barman_package_require=Class['epel']

          $barmanuser='barman'
          $barmangroup='barman'

          $barmanhome_default='/var/lib/barman'
          $barmanlog_default='/var/log/barman/barman.log'
          $barmanconfigdir_default='/etc/barman.d'
          $barmanconfigfile_default='/etc/barman.conf'

          $rsync_package='rsync'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
