class FrameModelsController < ApplicationController
    # new
    get '/frames/models/new' do
        erb :'/frames/models/new'
    end

    # create
    post '/frames/models' do
        if !FrameModel.find_by(name: params[:name])
            frame_model = FrameModel.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Frame model successfully created"}
            redirect "/frames/models/#{frame_model.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Frame model already exists"}
            redirect "/frames/models/#{frame_model.slug}"
        end
    end

    # show
    get '/frames/models/:slug' do
        @frame_model = FrameModel.find_by_slug_and_id(params[:slug], current_user.id)
        if @frame_model
            @racquets = get_ordered_racquets.collect { |racquet| racquet if racquet.frame_model == @frame_model }.compact
            # get ordered matches and filter by those that include racquets of the current frame model
            @matches = get_ordered_matches.collect do |match|
                match if match.racquets.collect { |racquet| racquet.frame_model }.include?(@frame_model)
            end.compact
            erb :'/frames/models/show'
        else
            flash[:message] = {:type => "warning", :content => "Frame model not found"}
            redirect '/frames'
        end
    end

    # edit
    get '/frames/models/:slug/edit' do
        @frame_model = FrameModel.find_by_slug_and_id(params[:slug], current_user.id)
        if @frame_model
            erb :'/frames/models/edit'
        else
            flash[:message] = {:type => "warning", :content => "Frame model not found"}
            redirect '/frames'
        end
    end

    # update
    patch '/frames/models/:slug' do
        frame_model = FrameModel.find_by_slug_and_id(params[:slug], current_user.id)
        frame_model.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Frame model successfully updated"}
        redirect "/frames/models/#{frame_model.slug}"
    end

    # destroy
    delete '/frames/models/:slug' do
        frame_model = FrameModel.find_by_slug_and_id(params[:slug], current_user.id)
        frame_model.racquets.each do |racquet|
            racquet.matches.each do |match|
                match.match_racquets.destroy_all
                match.destroy
            end
            racquet.destroy
        end
        frame_model.destroy

        flash[:message] = {:type => "primary", :content => "Frame model successfully deleted"}
        redirect "/frames"
    end
end