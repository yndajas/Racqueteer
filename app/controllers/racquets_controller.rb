class RacquetsController < ApplicationController
    # new
    get '/racquets/new' do
        @sports = Sport.where(user_id: current_user.id)
        @frame_brands = FrameBrand.where(user_id: current_user.id)
        @frame_models = FrameModel.where(user_id: current_user.id)
        @string_brands = StringBrand.where(user_id: current_user.id)
        @string_models = StringModel.where(user_id: current_user.id)
        erb :'/racquets/new'
    end

    # create
    post '/racquets' do
        racquet = Racquet.new
        racquet.user = current_user
        racquet.sport = Sport.find_or_create_by(:name => params[:sport], :user_id => current_user.id)
        racquet.frame_brand = FrameBrand.find_or_create_by(:name => params[:frame_brand], :user_id => current_user.id)
        racquet.frame_model = FrameModel.find_or_create_by(:name => params[:frame_model], :user_id => current_user.id)
        racquet.string_brand = StringBrand.find_or_create_by(:name => params[:string_brand], :user_id => current_user.id)
        racquet.string_model = StringModel.find_or_create_by(:name => params[:string_model], :user_id => current_user.id)
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
        # execute SQL to filter racquets by user then order by sport, frame brand, frame model, string model, string brand
        sql = <<-SQL
            SELECT id, user_id, sport, frame_brand, frame_model, string_brand, string_model, sport_id, frame_brand_id, frame_model_id, string_model_id, string_brand_id
            FROM (SELECT * FROM racquets WHERE user_id = #{current_user.id}) r
            INNER JOIN (SELECT id as sport_id2, name as sport FROM sports) s ON r.sport_id = s.sport_id2
            INNER JOIN (SELECT id as frame_brand_id2, name as frame_brand FROM frame_brands) fb ON r.frame_brand_id = fb.frame_brand_id2
            INNER JOIN (SELECT id as frame_model_id2, name as frame_model FROM frame_models) fb ON r.frame_model_id = fb.frame_model_id2
            INNER JOIN (SELECT id as string_brand_id2, name as string_brand FROM string_brands) fb ON r.string_brand_id = fb.string_brand_id2
            INNER JOIN (SELECT id as string_model_id2, name as string_model FROM string_models) fb ON r.string_model_id = fb.string_model_id2
            ORDER BY user_id, sport, frame_brand, frame_model, string_brand, string_model
        SQL
        @racquets = Racquet.find_by_sql(sql)
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
end