# vim: set ft=sh:

@test "it should create keepalived config" {
  test -f /etc/keepalived/keepalived.conf
}

@test "keepalived service must be running" {
  service keepalived | grep -qi ok
}
