class SportsController < ApplicationController
    get '/sports' do
        @sports = Sport.where(user_id: session[:user_id])
        erb :'/sports/index'
    end

    get '/sports/new' do
        erb :'/sports/new'
    end

    get '/sports/:slug' do
        @sport = Sport.find_by_slug(params[:slug])
        if @sport
            erb :'/sports/show'
        else
            flash[:message] = {:type => "warning", :content => "Sport not found"}
            redirect '/sports'
        end
    end
end