class Coach < ActiveRecord::Base
    belongs_to :user
    has_many :coaching_session_coaches
    has_many :coaching_sessions, through: :coaching_session_coaches
end