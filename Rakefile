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

# reset database - drop, migrate, seed
task :resetdb do
  Rake::Task["db:drop"].execute
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute 
  Rake::Task["db:seed"].execute 
end

# log object counts for user 1
task :objectcounts do
  puts "#{User.all.length} users\n\n"
  user = User.first
  puts "#{user.email}..."
  puts "#{user.sports.length} sports    | #{user.opponents.length} opponents         | #{user.locations.length} locations"
  puts "#{user.racquets.length} racquets  | #{user.frame_brands.length} frame brands      | #{user.frame_models.length} frame models | #{user.string_brands.length} string brands | #{user.string_models.length} string models"
  puts "#{user.matches.length} matches   | #{user.matches.collect { |match| match.match_racquets}.flatten.uniq.length } match racquets"
  puts "#{user.coaches.length} coaches   | #{user.coaching_sessions.length} coaching sessions | #{user.coaching_sessions.collect { |coaching_session| coaching_session.coaching_session_coaches }.flatten.uniq.length} coaching session coaches"
end
