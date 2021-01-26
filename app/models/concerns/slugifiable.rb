module Slugifiable
    module InstanceMethods
        def slug
            self.name.downcase.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/\-+/, '-')
        end
    end

    module ClassMethods
        def find_by_slug(slug)
            self.all.find { |instance| instance.slug == slug.downcase }
        end

        def find_by_slug_and_id(slug, id)
            self.where(user_id: id).find_by_slug(slug)
        end
    end
end