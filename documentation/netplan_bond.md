# netplan_bond

Writes a Netplan `bonds` fragment.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Writes the bond fragment. Default. |
| `:delete` | Deletes the bond fragment. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `interfaces` | Array | required for `:create` | Interfaces in the bond. |
| `parameters` | Hash, nil | `nil` | Bond parameters. |
| `config` | Hash | `{}` | Additional per-bond Netplan keys. |

Also supports the common typed interface properties documented in `netplan_ethernet.md`, plus shared file and execution properties.

## Examples

```ruby
netplan_bond 'bond0' do
  interfaces %w(eth1 eth2)
  parameters mode: '802.3ad', 'mii-monitor-interval': 100
  dhcp4 false
end
```
