class AddColumnToStories < ActiveRecord::Migration
  def change
    add_column :stories, :public, :boolean
  end
end
