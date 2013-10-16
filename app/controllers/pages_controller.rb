require 'arrowhead'

class PagesController < ActionController::Base
  layout "application"
  
  def about
  end

  def arrowhead
    @stories = Arrowhead.stories
  end
end
