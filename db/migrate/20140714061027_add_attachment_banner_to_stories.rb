class AddAttachmentBannerToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.attachment :banner
    end
  end

  def self.down
    drop_attached_file :stories, :banner
  end
end
