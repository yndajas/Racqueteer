class LocationsController < ApplicationController
    # new
    get '/locations/new' do
        erb :'/locations/new'
    end

    # create
    post '/locations' do
        if !Location.find_by(name: params[:name])
            location = Location.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Location successfully created"}
            redirect "/locations/#{location.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Location already exists"}
            redirect "/locations/#{location.slug}"
        end
    end

    # index
    get '/locations' do
        @locations = Location.where(user_id: current_user.id)
        erb :'/locations/index'
    end

    # show
    get '/locations/:slug' do
        @location = Location.find_by_slug_and_id(params[:slug], current_user.id)
        if @location
            # get ordered coaching sessions and filter by those that are at the current location
            @coaching_sessions = get_ordered_coaching_sessions.collect { |coaching_session| coaching_session if coaching_session.location == @location }.compact
            # get ordered matches and filter by those that are at the current location
            @matches = get_ordered_matches.collect { |match| match if match.location == @location }.compact
            erb :'/locations/show'
        else
            flash[:message] = {:type => "warning", :content => "Location not found"}
            redirect '/locations'
        end
    end

    # edit
    get '/locations/:slug/edit' do
        @location = Location.find_by_slug_and_id(params[:slug], current_user.id)
        if @location
            erb :'/locations/edit'
        else
            flash[:message] = {:type => "warning", :content => "Location not found"}
            redirect '/locations'
        end
    end

    # update
    patch '/locations/:slug' do
        location = Location.find_by_slug_and_id(params[:slug], current_user.id)
        location.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Location successfully updated"}
        redirect "/locations/#{location.slug}"
    end

    # destroy
    delete '/locations/:slug' do
        location = Location.find_by_slug_and_id(params[:slug], current_user.id)
        location.coaching_sessions.each do |coaching_session|
            coaching_session.coaching_session_coaches.destroy_all
            coaching_session.destroy
        end
        location.matches.each do |match|
            match.match_racquets.destroy.all
            match.destroy
        end
        location.destroy

        flash[:message] = {:type => "primary", :content => "Location successfully deleted"}
        redirect "/locations"
    end
end