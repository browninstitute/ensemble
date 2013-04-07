class AddSentToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :sent, :boolean, :default => false
  end
end
