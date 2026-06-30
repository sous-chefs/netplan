# frozen_string_literal: true

provides :netplan_config
unified_mode true

use '_partial/_config'

property :config, Hash, required: [:create]

default_action :create

action :create do
  netplan_install 'default' do
    action :install
    only_if { new_resource.install_package }
  end

  directory new_resource.config_dir do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    recursive true
  end

  execute "netplan generate for #{netplan_config_path}" do
    command 'netplan generate'
    action :nothing
    only_if { new_resource.validate_config }
  end

  execute "netplan apply for #{netplan_config_path}" do
    command new_resource.apply_command
    action :nothing
    only_if { new_resource.apply }
  end

  file netplan_config_path do
    content netplan_yaml(new_resource.config)
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    notifies :run, "execute[netplan generate for #{netplan_config_path}]", :immediately if new_resource.validate_config
    notifies :run, "execute[netplan apply for #{netplan_config_path}]", :immediately if new_resource.apply
  end
end

action :delete do
  execute "netplan generate for #{netplan_config_path}" do
    command 'netplan generate'
    action :nothing
    only_if { new_resource.validate_config }
  end

  execute "netplan apply for #{netplan_config_path}" do
    command new_resource.apply_command
    action :nothing
    only_if { new_resource.apply }
  end

  file netplan_config_path do
    action :delete
    notifies :run, "execute[netplan generate for #{netplan_config_path}]", :immediately if new_resource.validate_config
    notifies :run, "execute[netplan apply for #{netplan_config_path}]", :immediately if new_resource.apply
  end
end

action_class do
  include NetplanCookbook::Helpers
end
