# frozen_string_literal: true

managed_files = {
  '/etc/netplan/10-chef-raw.yaml' => ['chefraw0:', 'dhcp4: false'],
  '/etc/netplan/20-chef-ethernet.yaml' => ['chefeth0:', 'dhcp4: true'],
  '/etc/netplan/30-chef-bridge.yaml' => ['chefbr0:', 'interfaces:'],
  '/etc/netplan/35-chef-bond-members.yaml' => ['chefeth1:', 'chefeth2:'],
  '/etc/netplan/40-chef-bond.yaml' => ['chefbond0:', 'active-backup'],
  '/etc/netplan/50-chef-vlan.yaml' => ['chefvlan40:', 'id: 40', 'link: chefbond0'],
}

control 'netplan-package-01' do
  impact 1.0
  title 'The netplan package is installed'

  describe package('netplan.io') do
    it { should be_installed }
  end
end

control 'netplan-config-01' do
  impact 1.0
  title 'Managed Netplan YAML fragments exist with restricted permissions'

  managed_files.each do |path, expected_content|
    describe file(path) do
      it { should exist }
      it { should be_file }
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
      its('mode') { should cmp '0600' }

      expected_content.each do |content|
        its('content') { should include content }
      end
    end
  end
end

control 'netplan-generate-01' do
  impact 1.0
  title 'Netplan can generate backend configuration from managed YAML'

  describe command('netplan generate') do
    its('exit_status') { should eq 0 }
  end
end
