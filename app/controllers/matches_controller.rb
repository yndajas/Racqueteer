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
        if params[:date]
            match.start_date = params[:date]
            match.end_date = params[:date]
        else
            match.start_date = params[:start_date]
            match.end_date = params[:end_date]
        end
        match.score = params[:score]
        match.result = params[:result]
        match.save
        # iterate over racquets, creating a match_racquet for each
        if params[:racquet_ids]
            params[:racquet_ids].each do |racquet_id|
                MatchRacquet.create(:match_id => match.id, :racquet_id => racquet_id)
            end
        end
        # iterate over new_racquets, creating a new racquet and match_racquet for each (if length of frame_brand > 0)
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
        redirect "/matches/#{match.id}"
    end

    # create

    helpers do
        def get_associates
            get_ordered_racquets
            get_racquet_associates
            @locations = Location.where(user_id: current_user.id)
            @opponents = Opponent.where(user_id: current_user.id)
        end

        def set_associates(match)
            match.sport = Sport.find_or_create_by(:name => params[:sport], :user_id => current_user.id)
            match.location = Location.find_or_create_by(:name => params[:location], :user_id => current_user.id)
            match.opponent = Opponent.find_or_create_by(:name => params[:opponent], :user_id => current_user.id)
        end
    end
end