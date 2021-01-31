class FramesController < ApplicationController
    get '/frames' do
        @frame_brands = FrameBrand.where(user_id: current_user.id)
        @frame_models = FrameModel.where(user_id: current_user.id)
        erb :'/frames/index'
    end
end