class Sport < ActiveRecord::Base
    require_relative "./concerns/attributable"
    include Attributable

    has_many :racquets
    has_many :matches
    has_many :coaching_sessions
end