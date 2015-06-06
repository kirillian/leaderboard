source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.1'

gem 'draper', '~> 1.3'
gem 'foundation-rails', '~> 5.5.1.2'
gem 'jbuilder', '~> 2.0'
gem 'oj'
gem 'pg'
gem 'rabl'
gem 'responders'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'slim-rails'
gem 'turbolinks'

# CSS
gem 'sass-rails', '~> 5.0'

# Javascript
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'react-rails', '~> 1.0'
gem 'uglifier', '>= 1.3.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-modernizr', '~> 2.8.3'
end

group :development do
  gem 'puma'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'simplecov', require: false
  gem 'spring'
  gem 'web-console', '~> 2.0'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :production do
  # gem 'therubyracer', platforms: :ruby # remove if nodejs available. NodeJS is preferable
end

group :test do
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activejob'
end
