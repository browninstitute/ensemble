class DropStoryTexts < ActiveRecord::Migration
  def up
    drop_table :story_texts
  end

  def down
  end
end
