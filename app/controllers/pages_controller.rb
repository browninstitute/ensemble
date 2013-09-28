class PagesController < ActionController::Base
  layout "application"
  
  def about
  end

  def arrowhead
    @stories = Story.find_published( :order => "title", :conditions => ["user_id IN (?)", ARROWHEAD_USERIDS])
  end
end
