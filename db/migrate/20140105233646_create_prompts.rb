class CreatePrompts < ActiveRecord::Migration
  def change
    create_table :prompts do |t|
      t.string :title
      t.text :description
      t.datetime :opendate
      t.datetime :deadline
      t.integer :word_count
      t.integer :suggested_by_id
      t.string :image_url
      t.string :image_credit
      t.string :image_link_url

      t.timestamps
    end
  end
end
