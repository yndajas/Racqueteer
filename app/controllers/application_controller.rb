require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    # tell Sinatra where to find public and views folders
    set :public_folder, 'public'
    set :views, 'app/views'
    
    # enable sessions for persisting login data
    enable :sessions
    set :session_secret, 'indigo platypuses'
    
    # enable flash messages
    require 'rack-flash'
    use Rack::Flash

    # enable multiple yields in ERB layout
    helpers Sinatra::ContentFor
  end

  get '/' do
    if logged_in
      redirect '/dashboard'
    else
      erb :'/application/index'
    end
  end

  helpers do
    # check if user if logged in
    def logged_in
      !!session[:user_id]
    end

    # get current user instance
    def current_user
      User.find(session[:user_id])
    end
  end
end