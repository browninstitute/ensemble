class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string :title
      t.text :content
      t.references :user
      t.references :story

      t.timestamps
    end
    add_index :scenes, :user_id
    add_index :scenes, :story_id
  end
end
