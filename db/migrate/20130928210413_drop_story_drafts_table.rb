class DropStoryDraftsTable < ActiveRecord::Migration
  def up
    drop_table :story_drafts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
