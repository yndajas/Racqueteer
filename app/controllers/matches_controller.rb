class MatchesController < ApplicationController
    # new
    get '/matches/new' do
        get_associates
        erb :'/matches/new'
    end

    # create
    post '/matches' do
        match = Match.new
        match.user = current_user
        set_associates(match)
        set_basic_attributes(match)
        match.save
        set_racquets(match)
        flash[:message] = {:type => "success", :content => "Match successfully created"}
        redirect "/matches/#{match.id}"
    end

    # index
    get '/matches' do
        get_ordered_matches
        erb :'/matches/index'
    end

    # show
    get '/matches/:id' do
        @match = Match.where(:id => params[:id], :user_id => current_user.id)[0]
        if @match
            erb :'/matches/show'
        else
            flash[:message] = {:type => "warning", :content => "Match not found"}
            redirect '/matches'
        end
    end

    # edit
    get '/matches/:id/edit' do
        @match = Match.where(:id => params[:id], :user_id => current_user.id)[0]
        if @match
            get_associates
            erb :'/matches/edit'
        else
            flash[:message] = {:type => "warning", :content => "Match not found"}
            redirect '/matches'
        end
    end

    # update
    patch '/matches/:id' do
        match = Match.find(params[:id])
        set_associates(match)
        set_basic_attributes(match)
        match.save
        match.match_racquets.destroy_all
        set_racquets(match)
        flash[:message] = {:type => "success", :content => "Match successfully updated"}
        redirect "/matches/#{match.id}"
    end

    # destroy
    delete '/matches/:id' do
        match = Match.find(params[:id])
        match.match_racquets.destroy_all
        match.destroy
    end

    helpers do
        def get_associates
            get_ordered_racquets
            get_racquet_associates
            @locations = Location.where(user_id: current_user.id)
            @opponents = Opponent.where(user_id: current_user.id)
        end

        def get_ordered_matches
            sql = <<-SQL
                SELECT id, user_id, sport, opponent, start_date, end_date, result, sport_id, opponent_id
                FROM (SELECT * FROM matches WHERE user_id = #{current_user.id}) m
                INNER JOIN (SELECT id as sport_id2, name as sport FROM sports) s ON m.sport_id = s.sport_id2
                INNER JOIN (SELECT id as opponent_id2, name as opponent FROM opponents) o ON m.opponent_id = o.opponent_id2
                ORDER BY user_id, sport, start_date DESC, end_date DESC, opponent, result
            SQL
            @matches = Match.find_by_sql(sql)      
        end

        def set_associates(match)
            match.sport = Sport.find_or_create_by(:name => params[:sport], :user_id => current_user.id)
            match.location = Location.find_or_create_by(:name => params[:location], :user_id => current_user.id)
            match.opponent = Opponent.find_or_create_by(:name => params[:opponent], :user_id => current_user.id)
        end

        def set_basic_attributes(match)
            if params[:date]
                match.start_date = params[:date]
                match.end_date = params[:date]
            else
                match.start_date = params[:start_date]
                match.end_date = params[:end_date]
            end
            match.score = params[:score]
            match.result = params[:result]
        end

        def set_racquets(match)
            # iterate over racquets, creating a match_racquet for each
            if params[:racquet_ids]
                params[:racquet_ids].each do |racquet_id|
                    MatchRacquet.create(:match_id => match.id, :racquet_id => racquet_id)
                end
            end
            # iterate over new_racquets, creating a new racquet (or finding an existing racquet with the same attributes including sport and user) and match_racquet for each (if length of frame_brand > 0)
            params[:new_racquets].each do |new_racquet|
                if new_racquet[:frame_brand].length > 0
                    racquet = Racquet.find_or_create_by( \
                        :frame_brand_id => FrameBrand.find_or_create_by(:name => new_racquet[:frame_brand], :user_id => current_user.id).id, \
                        :frame_model_id => FrameModel.find_or_create_by(:name => new_racquet[:frame_model], :user_id => current_user.id).id, \
                        :string_brand_id => StringBrand.find_or_create_by(:name => new_racquet[:string_brand], :user_id => current_user.id).id, \
                        :string_model_id => StringModel.find_or_create_by(:name => new_racquet[:string_model], :user_id => current_user.id).id, \
                        :sport_id => match.sport.id, :user_id => current_user.id)
                    MatchRacquet.find_or_create_by(:match_id => match.id, :racquet_id => racquet.id)
                end
            end
        end        
    end
end