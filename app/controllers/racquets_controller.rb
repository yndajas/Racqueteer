class RacquetsController < ApplicationController
    # new
    get '/racquets/new' do
        get_racquet_associates
        erb :'/racquets/new'
    end

    # create
    post '/racquets' do
        racquet = Racquet.new
        racquet.user = current_user
        set_associates(racquet)
        existing_racquet = Racquet.where(:frame_brand_id => racquet.frame_brand.id, :frame_model_id => racquet.frame_model.id, :string_brand_id => racquet.string_brand.id, :string_model_id => racquet.string_model.id, :sport_id => racquet.sport.id, :user_id => current_user.id)[0]
        if !existing_racquet
            racquet.save
            flash[:message] = {:type => "success", :content => "Racquet successfully created"}
            redirect "/racquets/#{racquet.id}"
        else
            flash[:message] = {:type => "warning", :content => "Racquet already exists"}
            redirect "/racquets/#{existing_racquet.id}"
        end
    end

    # index
    get '/racquets' do
        get_ordered_racquets
        erb :'/racquets/index'
    end
    
    # show
    get '/racquets/:id' do
        @racquet = Racquet.where(:id => params[:id], :user_id => current_user.id)[0]
        if @racquet
            erb :'/racquets/show'
        else
            flash[:message] = {:type => "warning", :content => "Racquet not found"}
            redirect '/racquets'
        end
    end

    # edit
    get '/racquets/:id/edit' do
        @racquet = Racquet.where(:id => params[:id], :user_id => current_user.id)[0]
        if @racquet
            get_racquet_associates
            erb :'/racquets/edit'
        else
            flash[:message] = {:type => "warning", :content => "Racquet not found"}
            redirect '/racquets'
        end
    end

    # update
    patch '/racquets/:id' do
        racquet = Racquet.find(params[:id])
        set_associates(racquet)
        racquet.save
        flash[:message] = {:type => "success", :content => "Racquet successfully updated"}
        redirect "/racquets/#{racquet.id}"
    end

    # destroy
    delete '/racquets/:id' do
        racquet = Racquet.find(params[:id])

        # arrays for storing the found matches and match racquets
        match_racquets = []
        matches = []
        # get all match racquets belonging to the current racquet 
        MatchRacquet.where(racquet_id: racquet.id).each do |match_racquet|
            # add match in current match racquet to matches array
            matches << Match.find(match_racquet.match_id)
            # add all match racquets associated with match to match_racquets array (picking up match racquets that belong to other racquets but the same match, as well as current match racquet)
            match_racquets << MatchRacquet.where(match_id: match_racquet.match_id)
        end

        # destroy collected records
        match_racquets.flatten.uniq.each { |match_racquet| match_racquet.destroy }
        matches.uniq.each { |match| match.destroy }
        racquet.destroy

        flash[:message] = {:type => "primary", :content => "Racquet successfully deleted"}
        redirect "/racquets"
    end
    
    helpers do
        def set_associates(racquet)
            racquet.sport = Sport.find_or_create_by(:name => params[:sport], :user_id => current_user.id)
            racquet.frame_brand = FrameBrand.find_or_create_by(:name => params[:frame_brand], :user_id => current_user.id)
            racquet.frame_model = FrameModel.find_or_create_by(:name => params[:frame_model], :user_id => current_user.id)
            racquet.string_brand = StringBrand.find_or_create_by(:name => params[:string_brand], :user_id => current_user.id)
            racquet.string_model = StringModel.find_or_create_by(:name => params[:string_model], :user_id => current_user.id)    
        end
    end
end