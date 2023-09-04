# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

gem "bootsnap", require: false
gem "faraday"
gem "faraday-parse_dates"
gem "faraday-retry"
gem "pg"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.7", ">= 7.0.7.2"
gem "redis", "~> 4.0"
gem "sidekiq", ">= 7.0.8", "< 8"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem "web-console"
end

group :development, :test do
  gem "brakeman"
  gem "bundler-audit"
  gem "debug", platforms: %i[mri mingw x64_mingw]

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-thread_safety", require: false
end
