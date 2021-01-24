ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

task :console do # start a Pry console with the environment loaded using `rake console`
    Pry.start
end