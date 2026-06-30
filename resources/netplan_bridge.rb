# frozen_string_literal: true

provides :netplan_bridge
unified_mode true

use '_partial/_config'
use '_partial/_interface'

property :interfaces, Array, required: [:create]
property :parameters, [Hash, nil], default: nil

default_action :create

action :create do
  interface_config = common_interface_config(new_resource)
  interface_config['interfaces'] = new_resource.interfaces
  interface_config['parameters'] = new_resource.parameters unless new_resource.parameters.nil?

  netplan_config new_resource.name do
    filename new_resource.filename
    config_dir new_resource.config_dir
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    install_package new_resource.install_package
    validate_config new_resource.validate_config
    apply new_resource.apply
    apply_command new_resource.apply_command
    config netplan_document('bridges', new_resource.name, interface_config, new_resource.config, new_resource.renderer)
  end
end

action :delete do
  netplan_config new_resource.name do
    filename new_resource.filename
    config_dir new_resource.config_dir
    validate_config new_resource.validate_config
    apply new_resource.apply
    apply_command new_resource.apply_command
    action :delete
  end
end

action_class do
  include NetplanCookbook::Helpers
end
