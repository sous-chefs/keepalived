
# keepalived_virtual_server

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_virtual_server` resource can be used to configure a track script via a `virtual_server` configuration block.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `ip_address` | `String` | `nil` | Name Property, IPaddress + Port of the server, eg: `192.168.1.1 80`| |
| `real_servers` | `Array` | `nil` | Real Servers this is a virtual server for, will use include to load their files | |
| `ip_family` | `String` | `nil` | IP family for a fwmark service | `inet`, `inet6` |
| `delay_loop` | `Integer` | `nil` | delay timer for checker polling | |
| `lvs_sched` | `String` | `nil` | LVS scheduler | `rr`, `wrr`, `lc`, `wlc`, `lblc`, `sh`, `mh`, `dh`, `fo`, `ovf`, `lblcr`, `sed`, `nq` |
| `ops` | `true`, `false` | `nil` | Enable One-Packet-Scheduling for UDP | |
| `lvs_method` | `String` | `nil` | Default LVS forwarding method | `NAT`, `DR` |
| `persistence_engine` | `String` | `nil` | LVS persistence engine name | `sip` |
| `persistence_timeout` | `Integer` | `nil` | LVS persistence timeout in seconds | |
| `persistence_granularity` | `String` | `nil` | LVS granularity mask | |
| `protocol` | `String` | `nil` | L4 protocol | `TCP`, `UDP`, `SCTP` |
| `ha_suspend` | `true`, `false` | `nil` | If VS IP address is not set, suspend healthchecker's activity| |
| `virtualhost` | `String` | `nil` | Default VirtualHost string for HTTP_GET or SSL_GET | |
| `alpha` | `true`, `false` | `nil` | On daemon startup assume that all RSs are down and healthchecks failed| |
| `omega` | `true`, `false` | `nil` | On daemon shutdown consider quorum and RS down notifiers for execution, where appropriate | |
| `quorum` | `Integer` | `nil` | Minimum total weight of all live servers in the pool necessary to operate VS with no quality regression | |
| `hysteresis` | `Integer` | `nil` | Tolerate this much weight units compared to the nominal quorum, when considering quorum gain or loss | |
| `quorum_up` | `String` | `nil` | Script to execute when quorum is gained | |
| `quorum_down` | `String` | `nil` | Script to execute when quorum is lost | |
| `sorry_server` | `String` | `nil` | If a sorry server is configured, all real servers will be brought down when the quorum is not achieved| |
| `sorry_server_inhibit` | `true`, `false` | `nil` | applies inhibit_on_failure behaviour to the sorry_server | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, '00_keepalived_virtual_server__#{name}__.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `virtual_server.conf.erb` | Name of the template to render | |

## Examples

```ruby
frontends = search(:node, 'role:frontend')

frontends.each do |fe|
  keepalived_real_server fe.name do
    ipaddress fe['ipaddress']
    port 80
    weight 5
    notifies :restart, 'service[keepalived]', :delayed
  end
end

server_paths = frontends.map do |fe|
  resources(keepalived_real_server: fe.name).config_file
end

keepalived_virtual_server '192.168.1.5 80' do
  lb_kind 'NAT'
  virtualhost 'www.sous-chefs.org'
  sorry_server '127.0.0.1 8080'
  real_servers server_paths.to_a
  notifies :restart, 'service[keepalived]', :delayed
end
```
