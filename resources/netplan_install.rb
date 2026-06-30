# frozen_string_literal: true

provides :netplan_install
unified_mode true

property :package_name, String, default: 'netplan.io'

default_action :install

action :install do
  package new_resource.package_name
end

action :remove do
  package new_resource.package_name do
    action :remove
  end
end
