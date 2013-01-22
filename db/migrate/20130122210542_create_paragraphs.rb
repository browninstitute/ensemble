class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :title
      t.text :content
      t.integer :position
      t.references :user
      t.references :scene

      t.timestamps
    end
    add_index :paragraphs, :user_id
    add_index :paragraphs, :scene_id
  end
end
