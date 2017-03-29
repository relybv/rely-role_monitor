# == Class: role_monitor
#
# Full description of class role_monitor here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class role_monitor
{
  # a role includes one or more profiles and at least a 'base' profile
  include ::profile_telegraf
  include ::profile_influxdb

  # just for test, include application is auto monitor
  include role_monitor::apps
}
