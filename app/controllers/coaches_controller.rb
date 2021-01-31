class CoachesController < ApplicationController
    # new
    get '/coaches/new' do
        erb :'/coaches/new'
    end

    # create
    post '/coaches' do
        if !Coach.find_by(name: params[:name])
            coach = Coach.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Coach successfully created"}
            redirect "/coaches/#{coach.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Coach already exists"}
            redirect "/coaches/#{coach.slug}"
        end
    end

    # index
    get '/coaches' do
        @coaches = Coach.where(user_id: current_user.id)
        erb :'/coaches/index'
    end

    # show
    get '/coaches/:slug' do
        @coach = Coach.find_by_slug_and_id(params[:slug], current_user.id)
        if @coach
            # get ordered coaching sessions and filter by those that include the current coach
            @coaching_sessions = get_ordered_coaching_sessions.collect { |coaching_session| coaching_session if coaching_session.coaches.include?(@coach) }.compact
            erb :'/coaches/show'
        else
            flash[:message] = {:type => "warning", :content => "Coach not found"}
            redirect '/coaches'
        end
    end

    # edit
    get '/coaches/:slug/edit' do
        @coach = Coach.find_by_slug_and_id(params[:slug], current_user.id)
        if @coach
            erb :'/coaches/edit'
        else
            flash[:message] = {:type => "warning", :content => "Coach not found"}
            redirect '/coaches'
        end
    end

    # update
    patch '/coaches/:slug' do
        coach = Coach.find_by_slug_and_id(params[:slug], current_user.id)
        coach.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Coach successfully updated"}
        redirect "/coaches/#{coach.slug}"
    end

    # destroy
    delete '/coaches/:slug' do
        coach = Coach.find_by_slug_and_id(params[:slug], current_user.id)
        coach.coaching_sessions.each do |coaching_session|
            coaching_session.coaching_session_coaches.destroy_all
            coaching_session.destroy
        end        
        coach.destroy

        flash[:message] = {:type => "primary", :content => "Coach successfully deleted"}
        redirect "/coaches"
    end
end