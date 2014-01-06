class AddPromptRefToStories < ActiveRecord::Migration
  def change
    add_column :stories, :prompt_id, :integer
  end
end
