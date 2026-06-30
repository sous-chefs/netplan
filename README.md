# netplan

Provides custom resources to install Netplan and manage `/etc/netplan` YAML fragments on Debian and Ubuntu.

Netplan is a declarative network configuration renderer. This cookbook writes and validates YAML configuration, but it does not apply live networking changes unless a resource explicitly sets `apply true`.

## Resources

* `netplan_install`
* `netplan_config`
* `netplan_ethernet`
* `netplan_bridge`
* `netplan_bond`
* `netplan_vlan`

## Examples

Install Netplan:

```ruby
netplan_install 'default'
```

Write a raw YAML fragment and validate it with `netplan generate`:

```ruby
netplan_config '10-static' do
  config(
    network: {
      version: 2,
      renderer: 'networkd',
      ethernets: {
        eth0: {
          dhcp4: false,
          addresses: ['192.0.2.10/24'],
          nameservers: {
            addresses: ['192.0.2.53'],
          },
        },
      },
    }
  )
end
```

Manage a simple DHCP ethernet fragment without applying it live:

```ruby
netplan_ethernet 'eth0' do
  filename '20-eth0.yaml'
  renderer 'networkd'
  dhcp4 true
  optional true
end
```

Apply changed configuration explicitly:

```ruby
netplan_config '50-lan' do
  apply true
  config(
    network: {
      version: 2,
      renderer: 'networkd',
      ethernets: {
        eth0: {
          dhcp4: true,
        },
      },
    }
  )
end
```

## Documentation

See the files in `documentation/` for full resource properties and examples.
