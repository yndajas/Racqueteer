class MatchesController < ApplicationController
    # new
    get '/matches/new' do
        get_associates
        erb :'/matches/new'
    end

    # create
    # set_associates # sets sport, location and opponent
    # iterate over racquets, creating a match_racquet for each
    # iterate over new_racquets, creating a new racquet and match_racquet for each
    # if params[:date], set start and end date to this
    # else start_date = params[:start_date], end_date = params[:end_date]

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