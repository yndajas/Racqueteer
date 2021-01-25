class Sport < ActiveRecord::Base
    belongs_to :user
    has_many :racquets
    has_many :matches
end