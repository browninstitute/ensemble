class AddColumnsToPrompts < ActiveRecord::Migration
  def change
    add_column :prompts, :prizes, :text
    add_column :prompts, :vote_deadline, :datetime
  end
end
