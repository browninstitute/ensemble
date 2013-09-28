class AddDraftToStories < ActiveRecord::Migration
  def change
    add_column :stories, :draft, :boolean, :default => false
  end
end
