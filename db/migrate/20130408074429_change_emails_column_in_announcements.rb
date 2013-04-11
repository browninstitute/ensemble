class ChangeEmailsColumnInAnnouncements < ActiveRecord::Migration
  def up
    change_column :announcements, :email, :text
  end

  def down
    change_column :announcements, :email, :string
  end
end
