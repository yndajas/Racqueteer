class Racquet < ActiveRecord::Base
    belongs_to :frame_brand
    belongs_to :frame_model
    belongs_to :string_brand
    belongs_to :string_model
    belongs_to :sport
    belongs_to :user
end