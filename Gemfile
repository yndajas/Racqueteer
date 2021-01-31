source 'http://rubygems.org'

gem 'sinatra' # web app library
gem 'sinatra-contrib', :require => 'sinatra/content_for' # Sinatra extension, enables multiple yield blocks ('content_for')
gem 'activerecord', '~> 6.0.3.4', :require => 'active_record' # models in MVC
gem 'sinatra-activerecord', :require => 'sinatra/activerecord' # Sinatra x ActiveRecord
gem 'rake' # tasks
gem 'require_all' # require all relevant folders
gem 'bcrypt' # password hashing
gem 'rack-flash3' # flash messages

group :production do
    gem 'pg' # PostgreSQL database
end

group :development, :test do
    gem 'pry' # open console with binding (when `binding.pry` is run)
    gem 'shotgun' # auto-reload app on every change
    gem 'sqlite3' # SQLite database
    gem 'rails-erd' # entity relationship diagrams
    gem 'tux' # command line interface for web app
end