module Posts
  module Domain
    module ReadModel
      class Post < ApplicationRecord
        self.table_name = :view_list_posts
        self.primary_key = :id

        has_many :comments, -> { where(archived: false) }, class_name: ::Posts::Domain::Comment.name

        def self.filter_posts(filter, page_request, sort)
          filter_page(filter, page_request, sort)
        end
      end
    end
  end
end