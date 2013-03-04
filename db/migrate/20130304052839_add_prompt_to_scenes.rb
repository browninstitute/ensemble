class AddPromptToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :prompt, :text
  end
end
