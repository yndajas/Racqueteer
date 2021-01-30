class Opponent < ActiveRecord::Base
    require_relative "./concerns/attributable"
    include Attributable
    
    has_many :matches
end