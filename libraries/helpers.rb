# frozen_string_literal: true

require 'yaml'

module NetplanCookbook
  module Helpers
    COMMON_INTERFACE_CONFIG = {
      'dhcp4' => :dhcp4,
      'dhcp6' => :dhcp6,
      'accept-ra' => :accept_ra,
      'optional' => :optional,
      'addresses' => :addresses,
      'routes' => :routes,
      'nameservers' => :nameservers,
      'match' => :match,
      'set-name' => :set_name,
      'link-local' => :link_local,
      'mtu' => :mtu,
    }.freeze

    def netplan_config_path
      ::File.join(new_resource.config_dir, netplan_filename)
    end

    def netplan_filename
      filename = new_resource.filename || new_resource.name

      filename.end_with?('.yaml', '.yml') ? filename : "#{filename}.yaml"
    end

    def netplan_yaml(config)
      YAML.dump(normalize_config(config))
    end

    def normalize_config(value)
      case value
      when Hash
        value.each_with_object({}) do |(key, item), normalized|
          next if item.nil?

          normalized[key.to_s] = normalize_config(item)
        end
      when Array
        value.map { |item| normalize_config(item) }
      else
        value
      end
    end

    def deep_merge_config(base, overlay)
      normalize_config(base).merge(normalize_config(overlay)) do |_key, left, right|
        left.is_a?(Hash) && right.is_a?(Hash) ? deep_merge_config(left, right) : right
      end
    end

    def common_interface_config(resource)
      config = COMMON_INTERFACE_CONFIG.each_with_object({}) do |(netplan_key, property_name), values|
        value = resource.send(property_name)
        values[netplan_key] = value unless value.nil?
      end

      normalize_config(config)
    end

    def netplan_document(section, device_name, interface_config, extra_config, renderer)
      device_config = deep_merge_config(interface_config, extra_config)
      network_config = { 'version' => 2, section => { device_name => device_config } }
      network_config['renderer'] = renderer unless renderer.nil?

      { 'network' => network_config }
    end
  end
end
