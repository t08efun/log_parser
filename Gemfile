# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'dry-types'
gem 'dry-validation'

group :test, :development do
  gem 'rspec'
end

group :development do
  gem 'get_process_mem'
  gem 'reek'
  gem 'rubocop'
end

group :production do
end
