# == Class: role_monitor
#
# Full description of class role_monitor here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class role_monitor (
  $jobs = true,
){
  # a role includes one or more profiles and at least a 'base' profile
  include ::profile_telegraf
  include ::profile_telegraf::rspec_monitor
  include ::profile_influxdb
  include ::profile_influxdb::rspec_monitor
  include ::profile_elasticsearch
  include ::profile_elasticsearch::rspec_monitor
  include ::profile_beats
  include ::profile_beats::rspec_monitor
  include ::profile_mcollective
  include ::profile_mcollective::rspec_monitor
  class { '::profile_rundeck': jobs => $jobs, }
  include ::profile_rundeck::rspec_monitor
}
