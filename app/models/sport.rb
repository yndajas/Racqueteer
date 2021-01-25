class Sport < ActiveRecord::Base
    belongs_to :user
    has_many :racquets
    has_many :matches
    has_many :coaching_sessions

    require_relative "./concerns/slugifiable"
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end