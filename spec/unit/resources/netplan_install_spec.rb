# frozen_string_literal: true

require 'spec_helper'

describe 'netplan_install' do
  step_into :netplan_install
  platform 'ubuntu', '24.04'

  context 'with action :install' do
    recipe do
      netplan_install 'default'
    end

    it { is_expected.to install_package('netplan.io') }
  end

  context 'with action :remove' do
    recipe do
      netplan_install 'default' do
        action :remove
      end
    end

    it { is_expected.to remove_package('netplan.io') }
  end
end
