# vim: set ft=sh:

@test "it should create keepalived config" {
  test -f /etc/keepalived/keepalived.conf
}

# since service status not supported on all platforms
@test "it should be running" {
  ps -ef | grep -qi "keepalived"
}
