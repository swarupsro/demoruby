source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.1.3"
gem "sqlite3", "~> 1.6"
gem "puma", "~> 6.4"
gem "turbo-rails"
gem "stimulus-rails"
gem "importmap-rails"
gem "jbuilder"
gem "redis", "~> 5.0"
gem "bootsnap", require: false
gem "bcrypt", "~> 3.1"

group :development, :test do
  gem "byebug"
  gem "web-console"
end

group :development do
  gem "listen", "~> 3.7"
  gem "spring"
end

# Use capybara system tests with selenium
group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
