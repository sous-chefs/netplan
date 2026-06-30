# frozen_string_literal: true

property :renderer, [String, nil], equal_to: %w(networkd NetworkManager), default: nil
property :dhcp4, [true, false, nil], default: nil
property :dhcp6, [true, false, nil], default: nil
property :accept_ra, [true, false, nil], default: nil
property :optional, [true, false, nil], default: nil
property :addresses, [Array, nil], default: nil
property :routes, [Array, nil], default: nil
property :nameservers, [Hash, nil], default: nil
property :match, [Hash, nil], default: nil
property :set_name, [String, nil], default: nil
property :link_local, [Array, nil], default: nil
property :mtu, [Integer, nil], default: nil
property :config, Hash, default: lazy { {} }
