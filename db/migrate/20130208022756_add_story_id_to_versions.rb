class AddStoryIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :story_id, :integer
  end
end
