class AddGenresToStories < ActiveRecord::Migration
  def change
    add_column :stories, :genre1, :int
    add_column :stories, :genre2, :int
  end
end
