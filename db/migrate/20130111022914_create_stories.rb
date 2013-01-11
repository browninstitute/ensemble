class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :subtitle
      t.references :user

      t.timestamps
    end
    add_index :stories, :user_id
  end
end
