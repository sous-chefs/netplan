# frozen_string_literal: true

name 'netplan'

run_list 'test::default'

cookbook 'netplan', path: '.'
cookbook 'test', path: './test/cookbooks/test'
