# netplan_install

Installs or removes the distro Netplan package.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Installs `netplan.io`. Default. |
| `:remove` | Removes `netplan.io`. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `package_name` | String | `netplan.io` | Package to manage. |

## Examples

```ruby
netplan_install 'default'
```

```ruby
netplan_install 'default' do
  action :remove
end
```
