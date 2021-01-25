## code for using rails-erd in a Sinatra app (source, with minor adaptations to current app: https://alexc.link/blog/creating-entity-relationship-diagrams-with-sinatra-activerecord)

require "sinatra/base"
# ... other dependencies ...
require 'bundler'
Bundler.require(:default, ENV['SINATRA_ENV'])

$LOAD_PATH.unshift(File.join(__dir__))

require './app/controllers/application_controller.rb' # the Sinatra application
