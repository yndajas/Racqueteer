class User < ActiveRecord::Base
    has_secure_password
    has_many :coaches
    has_many :coaching_sessions
    has_many :frame_brands
    has_many :frame_models
    has_many :locations
    has_many :matches
    has_many :opponents
    has_many :racquets
    has_many :sports
    has_many :string_brands
    has_many :string_models

    def used_coaches
        self.coaching_sessions.collect { |coaching_session| coaching_session.coaches }.flatten.uniq
    end

    def used_frame_brands
        self.used_racquets.collect { |racquet| racquet.frame_brand }.flatten.uniq
    end

    def used_frame_models
        self.used_racquets.collect { |racquet| racquet.frame_model }.flatten.uniq
    end

    def used_locations
        (self.matches.collect { |match| match.location } + self.coaching_sessions.collect { |coaching_session| coaching_session.location }).flatten.uniq
    end

    def used_opponents
        self.matches.collect { |match| match.opponent }.flatten.uniq
    end

    def used_racquets
        self.matches.collect { |match| match.racquets }.flatten.uniq
    end

    def used_sports
        (self.matches.collect { |match| match.sport } + self.coaching_sessions.collect { |coaching_session| coaching_session.sport }).flatten.uniq
    end

    def used_string_brands
        self.used_racquets.collect { |racquet| racquet.string_brand }.flatten.uniq
    end
    
    def used_string_models
        self.used_racquets.collect { |racquet| racquet.string_model }.flatten.uniq
    end
end
  