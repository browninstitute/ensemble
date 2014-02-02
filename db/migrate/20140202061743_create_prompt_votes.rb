class CreatePromptVotes < ActiveRecord::Migration
  def change
    create_table :prompt_votes do |t|
      t.integer :prompt_id
      t.integer :story_id
      t.integer :user_id

      t.timestamps
    end
  end
end
