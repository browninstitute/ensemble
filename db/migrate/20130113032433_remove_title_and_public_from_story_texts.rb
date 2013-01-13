class RemoveTitleAndPublicFromStoryTexts < ActiveRecord::Migration
  def up
    remove_column :story_texts, :title
    remove_column :story_texts, :public
  end

  def down
    add_column :story_texts, :public, :boolean
    add_column :story_texts, :title, :string
  end
end
