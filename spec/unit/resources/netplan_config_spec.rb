# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe 'netplan_config' do
  step_into :netplan_config
  platform 'ubuntu', '24.04'

  context 'with default validation and no apply' do
    recipe do
      netplan_config '10-static' do
        config(
          network: {
            version: 2,
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
    end

    it { is_expected.to install_netplan_install('default') }

    it 'writes a root-only YAML fragment' do
      expect(chef_run).to create_file('/etc/netplan/10-static.yaml')
        .with(owner: 'root', group: 'root', mode: '0600')

      rendered = YAML.safe_load(chef_run.file('/etc/netplan/10-static.yaml').content)
      expect(rendered).to eq(
        'network' => {
          'version' => 2,
          'ethernets' => {
            'eth0' => {
              'dhcp4' => false,
              'addresses' => ['192.0.2.10/24'],
              'nameservers' => {
                'addresses' => ['192.0.2.53'],
              },
            },
          },
        }
      )
    end

    it 'validates changed config without applying live networking by default' do
      expect(chef_run).to nothing_execute('netplan generate for /etc/netplan/10-static.yaml')
        .with(command: 'netplan generate')
      expect(chef_run).to_not run_execute('netplan apply for /etc/netplan/10-static.yaml')

      file = chef_run.file('/etc/netplan/10-static.yaml')
      expect(file).to notify('execute[netplan generate for /etc/netplan/10-static.yaml]').to(:run).immediately
    end
  end

  context 'with a custom filename and apply enabled' do
    recipe do
      netplan_config 'static-lan' do
        filename '50-lan.yaml'
        apply true
        apply_command 'netplan apply'
        config('network' => { 'version' => 2 })
      end
    end

    it 'notifies apply after validation' do
      expect(chef_run).to create_file('/etc/netplan/50-lan.yaml')
      expect(chef_run).to nothing_execute('netplan apply for /etc/netplan/50-lan.yaml')
        .with(command: 'netplan apply')

      file = chef_run.file('/etc/netplan/50-lan.yaml')
      expect(file).to notify('execute[netplan generate for /etc/netplan/50-lan.yaml]').to(:run).immediately
      expect(file).to notify('execute[netplan apply for /etc/netplan/50-lan.yaml]').to(:run).immediately
    end
  end

  context 'with action :delete' do
    recipe do
      netplan_config '10-static' do
        action :delete
      end
    end

    it { is_expected.to delete_file('/etc/netplan/10-static.yaml') }
  end
end
