class StringBrand < ActiveRecord::Base
    require_relative "./concerns/attributable"
    include Attributable

    has_many :racquets
end