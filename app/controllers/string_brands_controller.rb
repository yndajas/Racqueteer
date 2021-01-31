class StringBrandsController < ApplicationController
    # new
    get '/strings/brands/new' do
        erb :'/strings/brands/new'
    end

    # create
    post '/strings/brands' do
        if !StringBrand.find_by(name: params[:name])
            string_brand = StringBrand.create(:name => params[:name], :user_id => current_user.id)
            flash[:message] = {:type => "success", :content => "String brand successfully created"}
            redirect "/strings/brands/#{string_brand.slug}"
        else
            flash[:message] = {:type => "warning", :content => "String brand already exists"}
            redirect "/strings/brands/#{string_brand.slug}"
        end
    end

    # show
    get '/strings/brands/:slug' do
        @string_brand = StringBrand.find_by_slug_and_id(params[:slug], current_user.id)
        if @string_brand
            @racquets = get_ordered_racquets.collect { |racquet| racquet if racquet.string_brand == @string_brand }.compact
            # get ordered matches and filter by those that include racquets of the current string brand
            @matches = get_ordered_matches.collect do |match|
                match if match.racquets.collect { |racquet| racquet.string_brand }.include?(@string_brand)
            end.compact
            erb :'/strings/brands/show'
        else
            flash[:message] = {:type => "warning", :content => "String brand not found"}
            redirect '/strings'
        end
    end

    # edit
    get '/strings/brands/:slug/edit' do
        @string_brand = StringBrand.find_by_slug_and_id(params[:slug], current_user.id)
        if @string_brand
            erb :'/strings/brands/edit'
        else
            flash[:message] = {:type => "warning", :content => "String brand not found"}
            redirect '/strings'
        end
    end

    # update
    patch '/strings/brands/:slug' do
        string_brand = StringBrand.find_by_slug_and_id(params[:slug], current_user.id)
        string_brand.update(name: params[:name])
        flash[:message] = {:type => "success", :content => "String brand successfully updated"}
        redirect "/strings/brands/#{string_brand.slug}"
    end

    # destroy
    delete '/strings/brands/:slug' do
        string_brand = StringBrand.find_by_slug_and_id(params[:slug], current_user.id)
        string_brand.racquets.each do |racquet|
            racquet.matches.each do |match|
                match.match_racquets.destroy_all
                match.destroy
            end
            racquet.destroy
        end
        string_brand.destroy

        flash[:message] = {:type => "primary", :content => "String brand successfully deleted"}
        redirect "/strings"
    end
end