ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

task :console do # start a Pry console with the environment loaded using `rake console`
    Pry.start
end

## code for using rails-erd in a Sinatra app (source, with minor adaptations to current app and WSL: https://alexc.link/blog/creating-entity-relationship-diagrams-with-sinatra-activerecord)

task :environment do
    require './boot'
  
    environment = ENV['SINATRA_ENV']
  
    if environment == 'development'
      load "rails_erd/tasks.rake"
    end
  end

desc "Generate ERD"
task :erd => :environment do
  Rake::Task[:erd_generate].invoke
end

task :erd_generate => ["erd:check_dependencies", "erd:options"] do
  Dir['models/*.rb'].each { |m| require m }
  puts "Generating Entity-Relationship Diagram for #{ActiveRecord::Base.descendants.length} models..."

  require "rails_erd/diagram/graphviz"
  file = RailsERD::Diagram::Graphviz.create

  puts "Done! Saved diagram to #{file}."

  `cmd.exe /C start #{file}`
end
