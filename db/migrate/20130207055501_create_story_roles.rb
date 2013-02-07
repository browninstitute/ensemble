class CreateStoryRoles < ActiveRecord::Migration
  def change
    create_table :story_roles do |t|
      t.references :story
      t.references :user
      t.string :role

      t.timestamps
    end
    add_index :story_roles, :story_id
    add_index :story_roles, :user_id
  end
end
