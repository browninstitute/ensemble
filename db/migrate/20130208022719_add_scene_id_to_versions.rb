class AddSceneIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :scene_id, :integer
  end
end
