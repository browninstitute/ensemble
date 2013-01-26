class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :content
      t.references :user
      t.references :scene

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :scene_id
  end
end
