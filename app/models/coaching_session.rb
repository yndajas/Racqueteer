class CoachingSession < ActiveRecord::Base
    belongs_to :sport
    belongs_to :location
    belongs_to :user
    has_many :coaching_session_coaches
    has_many :coaches, through: :coaching_session_coaches
end