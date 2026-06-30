# netplan_bridge

Writes a Netplan `bridges` fragment.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Writes the bridge fragment. Default. |
| `:delete` | Deletes the bridge fragment. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `interfaces` | Array | required for `:create` | Interfaces attached to the bridge. |
| `parameters` | Hash, nil | `nil` | Bridge parameters. |
| `config` | Hash | `{}` | Additional per-bridge Netplan keys. |

Also supports the common typed interface properties documented in `netplan_ethernet.md`, plus shared file and execution properties.

## Examples

```ruby
netplan_bridge 'br0' do
  interfaces ['eth0']
  dhcp4 false
  addresses ['192.0.2.20/24']
end
```
