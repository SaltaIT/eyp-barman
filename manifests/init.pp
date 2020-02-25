# == Class: barman
#
# === barman documentation
#
class barman(
              #install
              $sshkey_type               = undef,
              $sshkey_key                = undef,
              #config
              $barmanhome                = $barman::params::barmanhome_default,
              $barmanhome_username       = $barman::params::barmanuser,
              $barmanhome_group          = $barman::params::barmangroup,
              $barmanhome_mode           = '0755',
              $barmanlog                 = $barman::params::barmanlog_default,
              $barmanconfigdir           = $barman::params::barmanconfigdir_default,
              $barmanconfigdir_username  = 'root',
              $barmanconfigdir_group     = 'root',
              $barmanconfigdir_recurse   = true,
              $barmanconfigdir_purge     = true,
              $barmanconfigdir_mode      = '0755',
              $barmanconfigfile          = $barman::params::barmanconfigfile_default,
              $barmanconfigfile_username = 'root',
              $barmanconfigfile_group    = 'root',
              $barmanconfigfile_mode     = '0644',
              $compression               = 'gzip',
              $manage_package            = true,
              $package_ensure            = 'installed',
              $install_nagios_checks     = true,
            ) inherits barman::params {

  class { '::barman::install': } ->
  class { '::barman::config': } ~>
  class { '::barman::service': } ->
  Class['::barman']
}
