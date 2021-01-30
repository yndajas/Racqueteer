class OpponentsController < ApplicationController
    # new
    get '/opponents/new' do
        erb :'/opponents/new'
    end

    # create
    post '/opponents' do
        if !Opponent.find_by(name: params[:name])
            opponent = Opponent.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Opponent successfully created"}
            redirect "/opponents/#{opponent.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Opponent already exists"}
            redirect "/opponents/#{opponent.slug}"
        end
    end

    # index
    get '/opponents' do
        @opponents = Opponent.where(user_id: current_user.id)
        erb :'/opponents/index'
    end

    # show
    get '/opponents/:slug' do
        @opponent = Opponent.find_by_slug_and_id(params[:slug], current_user.id)
        if @opponent
            # get ordered matches and filter by those that are of the current opponent
            @matches = get_ordered_matches.collect { |match| match if match.opponent == @opponent }.compact
            erb :'/opponents/show'
        else
            flash[:message] = {:type => "warning", :content => "Opponent not found"}
            redirect '/opponents'
        end
    end

    # edit
    get '/opponents/:slug/edit' do
        @opponent = Opponent.find_by_slug_and_id(params[:slug], current_user.id)
        if @opponent
            erb :'/opponents/edit'
        else
            flash[:message] = {:type => "warning", :content => "Opponent not found"}
            redirect '/opponents'
        end
    end

    # update
    patch '/opponents/:slug' do
        opponent = Opponent.find_by_slug_and_id(params[:slug], current_user.id)
        opponent.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Opponent successfully updated"}
        redirect "/opponents/#{opponent.slug}"
    end

    # destroy
    delete '/opponents/:slug' do
        opponent = Opponent.find_by_slug_and_id(params[:slug], current_user.id)
                
        Match.where(opponent_id: opponent.id).each do |match|
            MatchRacquet.where(match_id: match.id).destroy_all
            match.destroy
        end
        
        opponent.destroy

        flash[:message] = {:type => "primary", :content => "Opponent successfully deleted"}
        redirect "/opponents"
    end
end