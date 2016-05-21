# Can be useful to override on Ubuntu
# e.g. 'keepalived/trusty-backports'
default['keepalived']['package'] = 'keepalived'

# Not supported in Debian 7 or Ubuntu 12
default['keepalived']['daemon_args'] = %w()

default['keepalived']['daemon_args_env_var'] = value_for_platform_family(
  debian: 'DAEMON_ARGS',
  default: 'KEEPALIVED_OPTIONS'
)

default['keepalived']['defaults_path'] = value_for_platform_family(
  debian: '/etc/default/keepalived',
  default: '/etc/sysconfig/keepalived'
)
