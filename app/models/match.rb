class Match < ActiveRecord::Base
    belongs_to :sport
    belongs_to :opponent
    belongs_to :location
    belongs_to :user
    has_many :match_racquets
    has_many :racquets, through: :match_racquets
end