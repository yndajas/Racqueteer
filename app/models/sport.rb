class Sport < ActiveRecord::Base
    belongs_to :user
    has_many :racquets
end