source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'factory_girl_rails'
gem 'faker', '~> 1.7'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # testing
  ###
  # rails generate rspec:install
  ###
  gem 'rspec-rails', '~> 3.5'

  ###
  # bundle exec guard init rspec
  ###
  gem 'guard-rspec', require: false

  gem 'webmock'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'rails_12factor', group: :production

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Api
gem 'grape'
gem 'grape-middleware-logger'
gem 'hashie-forbidden_attributes'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-entity'

gem 'rack-cors', :require => 'rack/cors'

gem 'figaro'

# upload images
gem 'mini_magick'
gem 'fog', require: 'fog/aws'
gem 'carrierwave'

# tags
gem 'acts-as-taggable-on', '~> 4.0'

# pagination
gem 'api-pagination'
gem 'kaminari'