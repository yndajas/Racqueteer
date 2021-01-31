class FrameBrandsController < ApplicationController
    # new
    get '/frames/brands/new' do
        erb :'/frames/brands/new'
    end

    # create
    post '/frames/brands' do
        if !FrameBrand.find_by(name: params[:name])
            frame_brand = FrameBrand.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "Frame brand successfully created"}
            redirect "/frames/brands/#{frame_brand.slug}"
        else
            flash[:message] = {:type => "warning", :content => "Frame brand already exists"}
            redirect "/frames/brands/#{frame_brand.slug}"
        end
    end

    # show
    get '/frames/brands/:slug' do
        @frame_brand = FrameBrand.find_by_slug_and_id(params[:slug], current_user.id)
        if @frame_brand
            @racquets = get_ordered_racquets.collect { |racquet| racquet if racquet.frame_brand == @frame_brand }.compact
            # get ordered matches and filter by those that include racquets of the current frame brand
            @matches = get_ordered_matches.collect do |match|
                match if match.racquets.collect { |racquet| racquet.frame_brand }.include?(@frame_brand)
            end.compact
            erb :'/frames/brands/show'
        else
            flash[:message] = {:type => "warning", :content => "Frame brand not found"}
            redirect '/frames'
        end
    end

    # edit
    get '/frames/brands/:slug/edit' do
        @frame_brand = FrameBrand.find_by_slug_and_id(params[:slug], current_user.id)
        if @frame_brand
            erb :'/frames/brands/edit'
        else
            flash[:message] = {:type => "warning", :content => "Frame brand not found"}
            redirect '/frames'
        end
    end

    # update
    patch '/frames/brands/:slug' do
        frame_brand = FrameBrand.find_by_slug_and_id(params[:slug], current_user.id)
        frame_brand.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "Frame brand successfully updated"}
        redirect "/frames/brands/#{frame_brand.slug}"
    end

    # destroy
    delete '/frames/brands/:slug' do
        frame_brand = FrameBrand.find_by_slug_and_id(params[:slug], current_user.id)
        frame_brand.racquets.each do |racquet|
            racquet.matches.each do |match|
                match.match_racquets.destroy_all
                match.destroy
            end
            racquet.destroy
        end
        frame_brand.destroy

        flash[:message] = {:type => "primary", :content => "Frame brand successfully deleted"}
        redirect "/frames"
    end
end