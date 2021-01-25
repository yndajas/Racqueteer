class CoachingSessionCoach < ActiveRecord::Base
    belongs_to :coaching_session
    belongs_to :coach
end