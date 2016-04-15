# == Class: barman
#
# === barman documentation
#
class barman(
              #install
              $sshkey_type      = undef,
              $sshkey_key       = undef,
              #config
              $barmanhome       = $barman::params::barmanhome_default,
              $barmanlog        = $barman::params::barmanlog_default,
              $barmanconfigdir  = $barman::params::barmanconfigdir_default,
              $barmanconfigfile = $barman::params::barmanconfigfile_default,
              $compression      = 'gzip',
              #service
              $manage_service   = true,
            ) inherits barman::params{

  class { '::barman::install':
    sshkey_type => $sshkey_type,
    sshkey_key  => $sshkey_key,
  } ->

  class { '::barman::config':
    barmanhome       => $barmanhome,
    barmanlog        => $barmanlog,
    barmanconfigdir  => $barmanconfigdir,
    barmanconfigfile => $barmanconfigfile,
    compression      => $compression,
  } ~>

  class { '::barman::service':
    manage_service => $manage_service,
  } ->

  Class['::barman']

}
