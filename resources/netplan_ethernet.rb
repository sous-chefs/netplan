# frozen_string_literal: true

provides :netplan_ethernet
unified_mode true

use '_partial/_config'
use '_partial/_interface'

default_action :create

action :create do
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
    config netplan_document(
      'ethernets',
      new_resource.name,
      common_interface_config(new_resource),
      new_resource.config,
      new_resource.renderer
    )
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
