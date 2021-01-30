class Coach < ActiveRecord::Base
    require_relative "./concerns/attributable"
    include Attributable

    has_many :coaching_session_coaches
    has_many :coaching_sessions, through: :coaching_session_coaches
end