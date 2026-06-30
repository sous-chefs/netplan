# netplan_vlan

Writes a Netplan `vlans` fragment.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Writes the VLAN fragment. Default. |
| `:delete` | Deletes the VLAN fragment. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | Integer | required for `:create` | VLAN ID. |
| `link` | String | required for `:create` | Parent link. |
| `config` | Hash | `{}` | Additional per-VLAN Netplan keys. |

Also supports the common typed interface properties documented in `netplan_ethernet.md`, plus shared file and execution properties.

## Examples

```ruby
netplan_vlan 'vlan40' do
  id 40
  link 'bond0'
  addresses ['192.0.2.40/24']
end
```
