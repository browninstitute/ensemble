class HomeController < ApplicationController

  def index
    @story = Story.find(:first)
  end

end
