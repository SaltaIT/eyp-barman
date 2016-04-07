# == Class: barman
#
# === barman documentation
#
class barman inherits barman::params{

  class { '::barman::install': } ->
  class { '::barman::config': } ~>
  class { '::barman::service': } ->
  Class['::barman']

}
