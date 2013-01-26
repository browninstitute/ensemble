class AddWinnerToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :winner_id, :integer
  end
end
