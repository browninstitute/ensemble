class CreateStoryTextDraftsTable < ActiveRecord::Migration
  def up
    create_table :story_text_drafts do |t|
      t.references :story_texts
      t.text "content"
      t.integer "story_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def down
    drop_table :story_text_drafts
  end
end
