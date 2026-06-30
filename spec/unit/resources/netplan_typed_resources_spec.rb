# frozen_string_literal: true

require 'spec_helper'

describe 'netplan_ethernet' do
  step_into :netplan_ethernet
  platform 'ubuntu', '24.04'

  recipe do
    netplan_ethernet 'eth0' do
      dhcp4 false
      addresses ['192.0.2.10/24']
      routes [{ to: 'default', via: '192.0.2.1' }]
      nameservers(addresses: ['192.0.2.53'])
      accept_ra false
      set_name 'lan0'
      match macaddress: '00:11:22:33:44:55'
      link_local []
      mtu 1500
    end
  end

  it 'delegates a normalized ethernet fragment to netplan_config' do
    expect(chef_run).to create_netplan_config('eth0').with(
      config: {
        'network' => {
          'version' => 2,
          'ethernets' => {
            'eth0' => {
              'dhcp4' => false,
              'addresses' => ['192.0.2.10/24'],
              'routes' => [{ 'to' => 'default', 'via' => '192.0.2.1' }],
              'nameservers' => { 'addresses' => ['192.0.2.53'] },
              'accept-ra' => false,
              'set-name' => 'lan0',
              'match' => { 'macaddress' => '00:11:22:33:44:55' },
              'link-local' => [],
              'mtu' => 1500,
            },
          },
        },
      }
    )
  end
end

describe 'netplan_bridge' do
  step_into :netplan_bridge
  platform 'ubuntu', '24.04'

  recipe do
    netplan_bridge 'br0' do
      interfaces ['eth0']
      dhcp4 false
      addresses ['198.51.100.10/24']
    end
  end

  it 'delegates bridge interfaces to netplan_config' do
    expect(chef_run).to create_netplan_config('br0').with(
      config: {
        'network' => {
          'version' => 2,
          'bridges' => {
            'br0' => {
              'interfaces' => ['eth0'],
              'dhcp4' => false,
              'addresses' => ['198.51.100.10/24'],
            },
          },
        },
      }
    )
  end
end

describe 'netplan_bond' do
  step_into :netplan_bond
  platform 'ubuntu', '24.04'

  recipe do
    netplan_bond 'bond0' do
      interfaces %w(eth1 eth2)
      parameters mode: '802.3ad', 'mii-monitor-interval': 100
      dhcp4 false
    end
  end

  it 'delegates bond parameters to netplan_config' do
    expect(chef_run).to create_netplan_config('bond0').with(
      config: {
        'network' => {
          'version' => 2,
          'bonds' => {
            'bond0' => {
              'interfaces' => %w(eth1 eth2),
              'parameters' => {
                'mode' => '802.3ad',
                'mii-monitor-interval' => 100,
              },
              'dhcp4' => false,
            },
          },
        },
      }
    )
  end
end

describe 'netplan_vlan' do
  step_into :netplan_vlan
  platform 'ubuntu', '24.04'

  recipe do
    netplan_vlan 'vlan40' do
      id 40
      link 'bond0'
      dhcp4 false
      config addresses: ['203.0.113.10/24']
    end
  end

  it 'delegates VLAN id and link to netplan_config' do
    expect(chef_run).to create_netplan_config('vlan40').with(
      config: {
        'network' => {
          'version' => 2,
          'vlans' => {
            'vlan40' => {
              'id' => 40,
              'link' => 'bond0',
              'dhcp4' => false,
              'addresses' => ['203.0.113.10/24'],
            },
          },
        },
      }
    )
  end
end
