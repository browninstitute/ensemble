class FixForeignKeyNameForDrafts < ActiveRecord::Migration
  def change
    rename_column :story_text_drafts, :story_texts_id, :story_text_id
  end
end
