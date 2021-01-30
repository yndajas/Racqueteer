class CoachingSessionsController < ApplicationController
    # new
    get '/coaching/new' do
        get_associates
        erb :'/coaching_sessions/new'
    end

    # create
    post '/coaching' do
        coaching_session = CoachingSession.new
        coaching_session.user = current_user
        set_associates(coaching_session)
        set_basic_attributes(coaching_session)
        coaching_session.save
        set_coaches(coaching_session)
        flash[:message] = {:type => "success", :content => "Coaching session successfully created"}
        redirect "/coaching/#{coaching_session.id}"
    end

    # index
    get '/coaching' do
        get_ordered_coaching_sessions
        erb :'/coaching_sessions/index'
    end

    # show
    get '/coaching/:id' do
        @coaching_session = CoachingSession.where(:id => params[:id], :user_id => current_user.id)[0]
        if @coaching_session
            erb :'/coaching_sessions/show'
        else
            flash[:message] = {:type => "warning", :content => "Coaching session not found"}
            redirect '/coaching'
        end
    end

    # edit
    get '/coaching/:id/edit' do
        @coaching_session = CoachingSession.where(:id => params[:id], :user_id => current_user.id)[0]
        if @coaching_session
            get_associates
            erb :'/coaching_sessions/edit'
        else
            flash[:message] = {:type => "warning", :content => "Coaching session not found"}
            redirect '/coaching'
        end
    end

    # destroy
    delete '/coaching/:id' do
        coaching_session = CoachingSession.find(params[:id])
        coaching_session.coaching_session_coaches.destroy_all
        coaching_session.destroy
        redirect '/coaching'
    end
        
    helpers do
        def get_associates
            @coaches = Coach.where(user_id: current_user.id)
            @locations = Location.where(user_id: current_user.id)
            @sports = Sport.where(user_id: current_user.id)    
        end

        def set_associates(coaching_session)
            coaching_session.sport = Sport.find_or_create_by(:name => params[:sport], :user_id => current_user.id)
            coaching_session.location = Location.find_or_create_by(:name => params[:location], :user_id => current_user.id)
        end
  
        def set_basic_attributes(coaching_session)
            coaching_session.date = params[:date]
            coaching_session.focus = params[:focus]
            coaching_session.notes = params[:notes]
        end

        def set_coaches(coaching_session)
            # iterate over coaches, creating a coaching_session_coach for each
            if params[:coach_ids]
                params[:coach_ids].each do |coach_id|
                    CoachingSessionCoach.create(:coaching_session_id => coaching_session.id, :coach_id => coach_id)
                end
            end
            # iterate over new_coaches, creating a new coach (or finding an existing coach with the same name and user) and coaching_session_coach for each
            params[:new_coaches].each do |new_coach_name|
                if new_coach_name.length > 0
                    coach = Coach.find_or_create_by(:name => new_coach_name, :user_id => current_user.id)
                    CoachingSessionCoach.find_or_create_by(:coaching_session_id => coaching_session.id, :coach_id => coach.id)
                end
            end
        end   
    end
end