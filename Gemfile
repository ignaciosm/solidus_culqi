# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

gem 'deface'
gem 'ffaker'
gem 'mysql2', '0.4.10'
gem 'pg', '~> 0.21'
gem 'puma'
gem 'solidus_auth_devise'
gem 'sqlite3'

gemspec
