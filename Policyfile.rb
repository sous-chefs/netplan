# frozen_string_literal: true

name 'netplan'

run_list 'test::default'

cookbook 'netplan', path: '.'
cookbook 'test', path: './test/cookbooks/test'

Dir.entries('./test/cookbooks/test/recipes').select { |file| file.end_with?('.rb') }.each do |recipe|
  recipe = recipe.delete_suffix('.rb')
  named_run_list :"#{recipe}", "test::#{recipe}"
end
