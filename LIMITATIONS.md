# Limitations

## Package Availability

Keepalived is available in the default package repositories for all supported platforms.
No vendor-specific repositories are required.

### APT (Debian/Ubuntu)

- Ubuntu 22.04: keepalived 2.2.4 (amd64, arm64)
- Ubuntu 24.04: keepalived 2.2.8 (amd64, arm64)
- Debian 12: keepalived 2.2.8 (amd64, arm64)
- Debian 13: keepalived 2.3.x (amd64, arm64)

### DNF/YUM (RHEL family)

- RHEL 8 / AlmaLinux 8 / Rocky Linux 8 / Oracle Linux 8: keepalived 2.1.5 (amd64, arm64)
- RHEL 9 / AlmaLinux 9 / Rocky Linux 9 / Oracle Linux 9 / CentOS Stream 9: keepalived 2.2.8 (amd64, arm64)
- RHEL 10 / AlmaLinux 10 / Rocky Linux 10 / Oracle Linux 10 / CentOS Stream 10: keepalived 2.3.x (amd64, arm64)
- Amazon Linux 2023: keepalived 2.2.8 (amd64, arm64)
- Fedora 42/43: keepalived 2.3.x (amd64, arm64)

### Zypper (SUSE)

- openSUSE Leap 15.6: keepalived available (amd64)
- openSUSE Leap 16.0: keepalived available (amd64)

## Architecture Limitations

- All major platforms provide both amd64 and arm64 packages
- openSUSE packages may be amd64-only depending on version

## Source/Compiled Installation

This cookbook uses package installation only. Source installation is not supported.

### Build Dependencies (if compiling from source)

| Platform Family | Packages                                                                |
|-----------------|-------------------------------------------------------------------------|
| Debian          | build-essential, libssl-dev, libnl-3-dev, libnl-genl-3-dev, libsnmp-dev |
| RHEL            | gcc, make, openssl-devel, libnl3-devel, net-snmp-devel                  |

## Container Limitations

- Keepalived requires `NET_ADMIN` and `NET_BROADCAST` capabilities
- VRRP functionality requires access to network interfaces (not available in Dokken containers)
- Integration testing of VRRP features requires the exec driver or real VMs

## Known Issues

- Dokken containers cannot test VRRP failover due to network namespace isolation
- The `vrrp_instance` resource manages configuration files only; actual VRRP behavior depends on network topology
