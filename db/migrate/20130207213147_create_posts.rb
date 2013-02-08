class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.references :story
      t.string :title
      t.text :message
      t.boolean :pinned
      t.string :ancestry

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :story_id
    add_index :posts, :ancestry
  end
end
