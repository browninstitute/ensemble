class CreateStoryTexts < ActiveRecord::Migration
  def change
    create_table :story_texts do |t|
      t.string :title
      t.text :content
      t.boolean :public
      t.references :story

      t.timestamps
    end
    add_index :story_texts, :story_id
  end
end
