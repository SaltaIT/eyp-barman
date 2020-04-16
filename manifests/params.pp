class barman::params {

  $postgres_port_default='5432'
  #fer 9.2 minim

  case $::osfamily
  {
    'redhat':
    {
      $barman_package=[ 'barman', 'python-psycopg2' ]
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
          $include_pgdb_repo=false
          $barman_package_install_options=[ { '--disablerepo' => 'pgdg94,pgdg95,pgdg96,pgdg10,pgdg11' } ]
        }
        /^7.*$/:
        {
          $include_epel=true
          $include_pgdb_repo=true
          $barman_package_install_options=undef
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
