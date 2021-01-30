module Attributable
    def self.included(base)
        base.send("require_relative", "./slugifiable")
        base.extend Slugifiable::ClassMethods
        base.include Slugifiable::InstanceMethods
        base.belongs_to :user
    end
end
  