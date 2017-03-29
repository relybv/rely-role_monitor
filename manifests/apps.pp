# == Class: role_monitor::apps
#
# Full description of class role_monitor::apps here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class role_monitor::apps
{
  # just for test, include application is auto monitor

  class { 'apache':
    mpm_module    => 'prefork',
    keepalive     => 'On',
    default_mods  => [
      'php',
      'headers',
      'rewrite',
      'expires',
    ],
  }
  class { 'apache::mod::status': }
}
