class UsersController < ApplicationController
    # homepage when logged in
    get '/dashboard' do
        if logged_in
            erb :'/users/dashboard'
        else
            redirect '/'
        end
    end

    get '/register' do
        if logged_in
            redirect '/dashboard'
        else
            erb :'/users/register'
        end
    end

    post '/register' do
        # create user if they don't exist; set flash message based on whether they already existed
        if !User.find_by(email: params[:email])
            User.create(:email => params[:email], :password => params[:password])
            flash[:message] = {:type => "success", :content => "Account created. Log in to start racqueteering!"}
        else
            flash[:message] = {:type => "warning", :content => "User exists. Try logging in"}
        end
        # redirect to log in page
        redirect '/login'
    end

    get '/login' do
        if logged_in
            redirect '/dashboard'
        else
            erb :'/users/login'
        end
    end

    post '/login' do
        user = User.find_by(email: params[:email])
        # if the user exists and the password is correct, log user in and redirect to dashboard
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/dashboard'
        # otherwise return to login page with flash message indicating failure
        else
            flash[:message] = {:type => "danger", :content => "Incorrect email and/or password. Try again, unless you're a hacker!"}
            redirect '/login'
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end
end