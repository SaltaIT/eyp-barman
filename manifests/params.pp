class barman::params {

  $postgres_port_default='5432'
  #fer 9.2 minim

  case $::osfamily
  {
    'redhat':
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
      case $::operatingsystemrelease
      {
        /^6.*$/:
        {
          $include_epel=true
        }
        /^7.*$/:
        {
          $include_epel=true
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
