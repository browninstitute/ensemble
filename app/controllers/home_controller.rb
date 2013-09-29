class HomeController < ApplicationController

  def index
    @stories = Story.find_published(:limit => 3, :order => "created_at DESC")
  end
end
