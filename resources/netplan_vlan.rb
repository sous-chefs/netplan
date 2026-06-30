# frozen_string_literal: true

provides :netplan_vlan
unified_mode true

use '_partial/_config'
use '_partial/_interface'

property :id, Integer, required: [:create]
property :link, String, required: [:create]

default_action :create

action :create do
  interface_config = common_interface_config(new_resource)
  interface_config['id'] = new_resource.id
  interface_config['link'] = new_resource.link

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
    config netplan_document('vlans', new_resource.name, interface_config, new_resource.config, new_resource.renderer)
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
