class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :title
      t.string :subtitle
      t.integer :genre1
      t.integer :genre2
      t.text :content
      t.integer :story_id
      t.integer :user_id

      t.timestamps
    end
  end
end
