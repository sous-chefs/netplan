# frozen_string_literal: true

netplan_install 'default'

netplan_config '10-chef-raw' do
  install_package false
  config(
    network: {
      version: 2,
      renderer: 'networkd',
      ethernets: {
        chefraw0: {
          dhcp4: false,
          optional: true,
        },
      },
    }
  )
end

netplan_ethernet 'chefeth0' do
  filename '20-chef-ethernet.yaml'
  install_package false
  renderer 'networkd'
  dhcp4 true
  optional true
end

netplan_bridge 'chefbr0' do
  filename '30-chef-bridge.yaml'
  install_package false
  renderer 'networkd'
  interfaces ['chefeth0']
  dhcp4 false
  optional true
end

netplan_config '35-chef-bond-members' do
  install_package false
  config(
    network: {
      version: 2,
      renderer: 'networkd',
      ethernets: {
        chefeth1: {
          dhcp4: false,
          optional: true,
        },
        chefeth2: {
          dhcp4: false,
          optional: true,
        },
      },
    }
  )
end

netplan_bond 'chefbond0' do
  filename '40-chef-bond.yaml'
  install_package false
  renderer 'networkd'
  interfaces %w(chefeth1 chefeth2)
  parameters mode: 'active-backup', 'mii-monitor-interval': 100
  dhcp4 false
  optional true
end

netplan_vlan 'chefvlan40' do
  filename '50-chef-vlan.yaml'
  install_package false
  renderer 'networkd'
  id 40
  link 'chefbond0'
  dhcp4 false
end
