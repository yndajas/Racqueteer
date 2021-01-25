class StringBrand < ActiveRecord::Base
    belongs_to :user
    has_many :racquets
end