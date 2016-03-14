source 'https://rubygems.org'

#NOTE! You'll need to comment this out when you deploy to Heroku... Leave it in when setting up a new app. WHY???? I couldn't install a Heroku-supported ruby version locally :(
#ruby '2.1.1'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'rails_12factor', group: :production

#not yet....
#gem 'omniauth'


#for handling money
gem "money-rails"
#gem "monetize"

#pagination
#gem "kaminari"
gem 'kaminari-bootstrap', '~> 3.0.1'


#bootstrap-generators
gem 'bootstrap-generators', '~> 3.3.4'

#for pretty select boxes
# use class="selectpicker"
gem 'bootstrap-select-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

#use slim for templates
gem 'slim-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


#authentication stuff
gem "omniauth-google-oauth2"

gem 'puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  #for live reload (and maybe other stuff, too)
  #gem 'guard'
  #gem 'guard-livereload', '~> 2.4', require: false

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
