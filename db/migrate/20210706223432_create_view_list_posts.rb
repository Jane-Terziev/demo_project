class CreateViewListPosts < ActiveRecord::Migration[6.0]
  def change
    create_view :view_list_posts
  end
end

