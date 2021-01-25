class Location < ActiveRecord::Base
    belongs_to :user
    has_many :matches
    has_many :coaching_sessions
end