class CreateAnnouncementsTable < ActiveRecord::Migration
  def change
    create_table :announcements do |t|                                                          
      t.string :email                                                                                        
      t.string :subject                                                                                       
      t.text :message
      t.timestamps
    end    
  end
end
