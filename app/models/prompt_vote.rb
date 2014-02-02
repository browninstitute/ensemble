class PromptVote < ActiveRecord::Base
  attr_accessible :prompt_id, :story_id, :user_id
end
