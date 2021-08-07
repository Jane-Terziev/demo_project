class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :archived, default: false
      t.references :post

      t.timestamps
    end
  end
end
