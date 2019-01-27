# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'activeadmin'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.1.3'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'country_select'
gem 'devise'
gem 'draper'
gem 'icalendar'
gem 'inky-rb', require: 'inky'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'premailer-rails'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'redis', '~> 4.0'
gem 'rest-client'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :production do
  gem 'mailgun-ruby', '~>1.1.6'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'factory_bot'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '4.0.0.rc1'
end
