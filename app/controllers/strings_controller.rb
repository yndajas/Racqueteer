class StringsController < ApplicationController
    get '/strings' do
        @string_brands = StringBrand.where(user_id: current_user.id)
        @string_models = StringModel.where(user_id: current_user.id)
        erb :'/strings/index'
    end
end