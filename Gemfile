source 'https://rubygems.org'
# main
ruby '2.2.5'
gem 'rails', '4.2.7'
gem 'pg'

# front-end
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'slim'
gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

# Using Devise for authorization
gem 'devise'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'faker'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'

# pub/sub
gem 'private_pub'
gem 'thin'

# responders
gem 'responders'

# OAuth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

# Authorization
gem 'cancancan'

# API
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

# Background Jobs
gem 'sidekiq'
gem 'sinatra','>= 1.3.0', require: nil
gem 'whenever', :require => false

group :development do
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
end

group :test do
  gem 'json_spec'
  gem 'capybara-email'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
