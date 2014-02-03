class AddPrivacyToStories < ActiveRecord::Migration
  def change
    add_column :stories, :privacy, :integer, :default => 1
  end
end
