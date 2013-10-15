class PagesController < ActionController::Base
  layout "application"
  
  def about
  end

  def arrowhead
    @stories = Story.find_published( :order => "title", :conditions => ["user_id IN (?) AND title LIKE ?", ARROWHEAD_USERIDS, "Arrowhead%"])
  end
end
