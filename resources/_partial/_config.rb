# frozen_string_literal: true

property :filename, [String, nil], default: nil
property :config_dir, String, default: '/etc/netplan'
property :owner, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0600'
property :install_package, [true, false], default: true
property :validate_config, [true, false], default: true
property :apply, [true, false], default: false
property :apply_command, String, default: 'netplan apply'
