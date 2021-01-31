class StringModelsController < ApplicationController
    # new
    get '/strings/models/new' do
        erb :'/strings/models/new'
    end

    # create
    post '/strings/models' do
        if !StringModel.find_by(name: params[:name])
            string_model = StringModel.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "String model successfully created"}
            redirect "/strings/models/#{string_model.slug}"
        else
            flash[:message] = {:type => "warning", :content => "String model already exists"}
            redirect "/strings/models/#{string_model.slug}"
        end
    end

    # show
    get '/strings/models/:slug' do
        @string_model = StringModel.find_by_slug_and_id(params[:slug], current_user.id)
        if @string_model
            @racquets = get_ordered_racquets.collect { |racquet| racquet if racquet.string_model == @string_model }.compact
            # get ordered matches and filter by those that include racquets of the current string model
            @matches = get_ordered_matches.collect do |match|
                match if match.racquets.collect { |racquet| racquet.string_model }.include?(@string_model)
            end.compact
            erb :'/strings/models/show'
        else
            flash[:message] = {:type => "warning", :content => "String model not found"}
            redirect '/strings'
        end
    end

    # edit
    get '/strings/models/:slug/edit' do
        @string_model = StringModel.find_by_slug_and_id(params[:slug], current_user.id)
        if @string_model
            erb :'/strings/models/edit'
        else
            flash[:message] = {:type => "warning", :content => "String model not found"}
            redirect '/strings'
        end
    end

    # update
    patch '/strings/models/:slug' do
        string_model = StringModel.find_by_slug_and_id(params[:slug], current_user.id)
        string_model.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "String model successfully updated"}
        redirect "/strings/models/#{string_model.slug}"
    end

    # destroy
    delete '/strings/models/:slug' do
        string_model = StringModel.find_by_slug_and_id(params[:slug], current_user.id)
        string_model.racquets.each do |racquet|
            racquet.matches.each do |match|
                match.match_racquets.destroy_all
                match.destroy
            end
            racquet.destroy
        end
        string_model.destroy

        flash[:message] = {:type => "primary", :content => "String model successfully deleted"}
        redirect "/strings"
    end
end