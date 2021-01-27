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

  before do
    # remove any trailing slashes (1+) except when full request path is '/'
    if request.path != '/' && request.path[-1] == '/'
      path = request.path
      path = path[0..-2] until path[-1] != '/'
      redirect path
    end

    # redirect to a downcased version of the request path if the request is not lower case
    redirect "#{request.path.downcase}" if request.path != request.path.downcase

    # redirect to homepage when logged out unless path is '/', '/login', '/register' or post '/users'
    if !logged_in && request.path != '/' && request.path != '/login' && request.path != '/register' && !(request.post? && request.path == '/users')
      redirect '/'
    end

    # remove leading/trailing whitespace in params (on post/patch requests)
    if request.post? || request.patch?
      params.each { |key, value| params[key] = value.strip }
    end
  end
end