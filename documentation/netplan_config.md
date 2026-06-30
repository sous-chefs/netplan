# netplan_config

Writes a Netplan YAML fragment under `/etc/netplan`.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Writes the YAML fragment and runs `netplan generate` when the file changes. Default. |
| `:delete` | Deletes the YAML fragment and runs `netplan generate` when the file changes. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `config` | Hash | required for `:create` | Netplan YAML content as a Ruby hash. Symbol keys are normalized to strings. |
| `filename` | String, nil | resource name plus `.yaml` | Filename under `config_dir`. |
| `config_dir` | String | `/etc/netplan` | Directory for managed YAML fragments. |
| `owner` | String | `root` | File owner. |
| `group` | String | `root` | File group. |
| `mode` | String | `0600` | File mode. |
| `install_package` | true, false | `true` | Install `netplan.io` before writing the fragment. |
| `validate_config` | true, false | `true` | Run `netplan generate` when the fragment changes. |
| `apply` | true, false | `false` | Run `apply_command` when the fragment changes. |
| `apply_command` | String | `netplan apply` | Command used when `apply true` is set. |

## Examples

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
        },
      },
    }
  )
end
```

```ruby
netplan_config '50-lan' do
  apply true
  config('network' => { 'version' => 2 })
end
```
