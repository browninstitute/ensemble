class RenameStoryTextDrafts < ActiveRecord::Migration
  def up
    rename_table :story_text_drafts, :story_drafts
    add_column :story_drafts, :title, :string
    add_column :story_drafts, :subtitle, :string
    add_column :story_drafts, :user_id, :integer
    add_column :story_drafts, :public, :boolean
    remove_column :story_drafts, :story_text_id
  end

  def down
    rename_table :story_drafts, :story_text_drafts
    remove_column :story_text_drafts, :title
    remove_column :story_text_drafts, :subtitle
    remove_column :story_text_drafts, :user_id
    remove_column :story_text_drafts, :public
    add_column :story_text_drafts, :story_text_id, :integer
  end
end
