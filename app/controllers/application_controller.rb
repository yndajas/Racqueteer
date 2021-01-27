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

    def get_ordered_racquets
      # execute SQL to filter racquets by user then order by sport, frame brand, frame model, string model, string brand
      sql = <<-SQL
      SELECT id, user_id, sport, frame_brand, frame_model, string_brand, string_model, sport_id, frame_brand_id, frame_model_id, string_model_id, string_brand_id
      FROM (SELECT * FROM racquets WHERE user_id = #{current_user.id}) r
      INNER JOIN (SELECT id as sport_id2, name as sport FROM sports) s ON r.sport_id = s.sport_id2
      INNER JOIN (SELECT id as frame_brand_id2, name as frame_brand FROM frame_brands) fb ON r.frame_brand_id = fb.frame_brand_id2
      INNER JOIN (SELECT id as frame_model_id2, name as frame_model FROM frame_models) fb ON r.frame_model_id = fb.frame_model_id2
      INNER JOIN (SELECT id as string_brand_id2, name as string_brand FROM string_brands) fb ON r.string_brand_id = fb.string_brand_id2
      INNER JOIN (SELECT id as string_model_id2, name as string_model FROM string_models) fb ON r.string_model_id = fb.string_model_id2
      ORDER BY user_id, sport, frame_brand, frame_model, string_brand, string_model
      SQL
      @racquets = Racquet.find_by_sql(sql)
    end

    def get_racquet_associates
      @sports = Sport.where(user_id: current_user.id)
      @frame_brands = FrameBrand.where(user_id: current_user.id)
      @frame_models = FrameModel.where(user_id: current_user.id)
      @string_brands = StringBrand.where(user_id: current_user.id)
      @string_models = StringModel.where(user_id: current_user.id)
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
    # this may be redundant as values are trimmed client side via the trim_inputs.js script (which should also prevent whitespace alone in a required field being submittable), but this is an extra safeguard
    if request.post? || request.patch?
      params.each { |key, value| params[key] = value.strip }
    end
  end
end