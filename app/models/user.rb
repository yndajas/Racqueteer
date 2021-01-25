class User < ActiveRecord::Base
    has_secure_password
    has_many :sports
    has_many :racquets
    has_many :frame_brands
    has_many :frame_models
    has_many :string_brands
    has_many :string_models
end
  