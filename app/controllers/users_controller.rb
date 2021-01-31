class UsersController < ApplicationController
    # show/landing page when logged in
    get '/dashboard' do
        @sports = Sport.where(user_id: current_user.id)
        # get racquets (not ordered by sport)
        sql = <<-SQL
            SELECT id, user_id, frame_brand, frame_model, string_brand, string_model, frame_brand_id, frame_model_id, string_model_id, string_brand_id
            FROM (SELECT * FROM racquets WHERE user_id = #{current_user.id}) r
            INNER JOIN (SELECT id as frame_brand_id2, name as frame_brand FROM frame_brands) fb ON r.frame_brand_id = fb.frame_brand_id2
            INNER JOIN (SELECT id as frame_model_id2, name as frame_model FROM frame_models) fm ON r.frame_model_id = fm.frame_model_id2
            INNER JOIN (SELECT id as string_brand_id2, name as string_brand FROM string_brands) sb ON r.string_brand_id = sb.string_brand_id2
            INNER JOIN (SELECT id as string_model_id2, name as string_model FROM string_models) sm ON r.string_model_id = sm.string_model_id2
            ORDER BY LOWER(frame_brand), LOWER(frame_model), LOWER(string_brand), LOWER(string_model)
        SQL
        @racquets = Racquet.find_by_sql(sql)
        # get five most recent matches (not ordered by sport)
        sql = <<-SQL
            SELECT id, user_id, sport, opponent, start_date, end_date, result_id, sport_id, opponent_id
            FROM (SELECT * FROM matches WHERE user_id = #{current_user.id}) m
            INNER JOIN (SELECT id as sport_id2, name as sport FROM sports) s ON m.sport_id = s.sport_id2
            INNER JOIN (SELECT id as opponent_id2, name as opponent FROM opponents) o ON m.opponent_id = o.opponent_id2
            ORDER BY start_date DESC, end_date DESC, LOWER(opponent), result_id
            LIMIT 5
        SQL
        @recent_matches = Match.find_by_sql(sql)
        # get five most recent coaching sessions (not ordered by sport)
        sql = <<-SQL
            SELECT id, user_id, sport, focus, date, sport_id
            FROM (SELECT * FROM coaching_sessions WHERE user_id = #{current_user.id}) cs
            INNER JOIN (SELECT id as sport_id2, name as sport FROM sports) s ON cs.sport_id = s.sport_id2
            ORDER BY date DESC, LOWER(focus)
            LIMIT 5
        SQL
        @recent_coaching_sessions = CoachingSession.find_by_sql(sql)
        erb :'/users/dashboard'
    end

    # new
    get '/register' do
        redirect '/dashboard' if logged_in
        erb :'/users/register'
    end

    # create
    post '/users' do
        # create user if they don't exist; set flash message based on whether they already existed
        if !User.find_by(email: params[:email])
            User.create(:email => params[:email], :password => params[:password])
            flash[:message] = {:type => "success", :content => "Account created. Log in to start racqueteering!"}
        else
            flash[:message] = {:type => "warning", :content => "User already exists. Try logging in"}
        end
        # redirect to log in page
        redirect '/login'
    end

    # edit
    get '/account' do
        erb :'/users/edit'
    end

    # update
    patch '/users/:id' do
        user = User.find(params[:id])
        if user.authenticate(params[:password])
            if params[:email]
                user.update(email: params[:email])
                flash[:message] = {:type => "success", :content => "Email successfully updated"}
                redirect '/account'
            else
                user.update(password: params[:new_password])
                flash[:message] = {:type => "success", :content => "Password successfully updated"}
                redirect '/account'
            end
        else
            flash[:message] = {:type => "danger", :content => "Incorrect password. Try again, unless you're a hacker!"}
            redirect '/account'
        end
    end

    # destroy
    delete '/users/:id' do
        user = User.find(params[:id])

        CoachingSession.where(user_id: user.id).each do |coaching_session|
            CoachingSessionCoach.where(coaching_session_id: coaching_session.id).destroy_all
            coaching_session.destroy
        end

        Match.where(user_id: user.id).each do |match|
            MatchRacquet.where(match_id: match.id).destroy_all
            match.destroy
        end

        Coach.where(user_id: user.id).destroy_all
        FrameBrand.where(user_id: user.id).destroy_all
        FrameModel.where(user_id: user.id).destroy_all
        Location.where(user_id: user.id).destroy_all
        Opponent.where(user_id: user.id).destroy_all
        Racquet.where(user_id: user.id).destroy_all
        Sport.where(user_id: user.id).destroy_all
        StringBrand.where(user_id: user.id).destroy_all
        StringModel.where(user_id: user.id).destroy_all

        user.destroy
        session.clear

        flash[:message] = {:type => "primary", :content => "Account successfully deleted"}
        redirect '/'
    end

    get '/login' do
        redirect '/dashboard' if logged_in
        erb :'/users/login'
    end

    post '/login' do
        user = User.find_by(email: params[:email])
        # if the user exists and the password is correct, log user in and redirect to dashboard
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/dashboard'
        # otherwise return to login page with flash message indicating failure
        else
            flash[:message] = {:type => "danger", :content => "Incorrect email and/or password. Try again, unless you're a hacker!"}
            redirect '/login'
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end
end