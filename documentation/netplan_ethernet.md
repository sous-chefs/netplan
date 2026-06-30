# netplan_ethernet

Writes a Netplan `ethernets` fragment for one interface.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Writes the ethernet fragment. Default. |
| `:delete` | Deletes the ethernet fragment. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | String, nil | resource name plus `.yaml` | Filename under `config_dir`. |
| `renderer` | String, nil | `nil` | Top-level Netplan renderer: `networkd` or `NetworkManager`. |
| `dhcp4`, `dhcp6` | true, false, nil | `nil` | DHCP settings. |
| `accept_ra` | true, false, nil | `nil` | Writes `accept-ra`. |
| `optional` | true, false, nil | `nil` | Marks the interface optional. |
| `addresses` | Array, nil | `nil` | Static addresses. |
| `routes` | Array, nil | `nil` | Route entries. |
| `nameservers` | Hash, nil | `nil` | Nameserver configuration. |
| `match` | Hash, nil | `nil` | Match rules. |
| `set_name` | String, nil | `nil` | Writes `set-name`. |
| `link_local` | Array, nil | `nil` | Writes `link-local`. |
| `mtu` | Integer, nil | `nil` | MTU. |
| `config` | Hash | `{}` | Additional per-interface Netplan keys. |

Shared file and execution properties: `config_dir`, `owner`, `group`, `mode`, `install_package`, `validate_config`, `apply`, and `apply_command`.

## Examples

```ruby
netplan_ethernet 'eth0' do
  filename '20-eth0.yaml'
  renderer 'networkd'
  dhcp4 true
  optional true
end
```
