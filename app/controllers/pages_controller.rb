class PagesController < ActionController::Base
  layout "application"
  
  def about
  end

  def arrowhead
    @stories = Story.where(user_id: ARROWHEAD_USERIDS).order("title").all
  end
end
