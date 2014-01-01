class CreateStoryFlagsTable < ActiveRecord::Migration
  def up
    create_table :story_flags do |t|
      t.references :user
      t.references :story
      t.string :reason
    end
  end

  def down
    drop_table :story_flags
  end
end
