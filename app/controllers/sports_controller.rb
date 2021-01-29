class SportsController < ApplicationController
    # new
    get '/sports/new' do
        erb :'/sports/new'
    end

    # create
    post '/sports' do
        if !Sport.find_by(name: params[:name])
            sport = Sport.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Sport successfully created"}
            redirect "/sports/#{sport.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Sport already exists"}
            redirect "/sports/#{sport.slug}"
        end
    end

    # index
    get '/sports' do
        @sports = Sport.where(user_id: current_user.id)
        erb :'/sports/index'
    end

    # show
    get '/sports/:slug' do
        @sport = Sport.find_by_slug_and_id(params[:slug], current_user.id)
        if @sport
            # get ordered racquets and filter by those that are for the current sport
            @racquets = get_ordered_racquets.collect { |racquet| racquet if racquet.sport == @sport }.compact
            # get ordered matches and filter by those that are of the current sport
            @matches = get_ordered_matches.collect { |match| match if match.sport == @sport }.compact
            # get ordered coaching sessions and filter by those that are of the current sport
            @coaching_sessions = get_ordered_coaching_sessions.collect { |coaching_session| coaching_session if coaching_session.sport == @sport }.compact
            erb :'/sports/show'
        else
            flash[:message] = {:type => "warning", :content => "Sport not found"}
            redirect '/sports'
        end
    end

    # edit
    get '/sports/:slug/edit' do
        @sport = Sport.find_by_slug_and_id(params[:slug], current_user.id)
        if @sport
            erb :'/sports/edit'
        else
            flash[:message] = {:type => "warning", :content => "Sport not found"}
            redirect '/sports'
        end
    end

    # update
    patch '/sports/:slug' do
        sport = Sport.find_by_slug_and_id(params[:slug], current_user.id)
        sport.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Sport successfully updated"}
        redirect "/sports/#{sport.slug}"
    end

    # destroy
    delete '/sports/:slug' do
        sport = Sport.find_by_slug_and_id(params[:slug], current_user.id)
        
        CoachingSession.where(sport_id: sport.id).each do |coaching_session|
            CoachingSessionCoach.where(coaching_session_id: coaching_session.id).destroy_all
            coaching_session.destroy
        end
        
        Match.where(sport_id: sport.id).each do |match|
            MatchRacquet.where(match_id: match.id).destroy_all
            match.destroy
        end

        Racquet.where(sport_id: sport.id).each do |racquet|
            MatchRacquet.where(racquet_id: racquet.id).destroy_all
            racquet.destroy
        end
        
        sport.destroy

        flash[:message] = {:type => "primary", :content => "Sport successfully deleted"}
        redirect "/sports"
    end
end