class Comment < ApplicationRecord
  belongs_to :post, class_name: Post.name

  def self.create_new(title:, body:)
    new(
        title: title,
        body: body
    )
  end
end