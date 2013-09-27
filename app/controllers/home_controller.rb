class HomeController < ApplicationController

  def index
    @stories = Story.find(:all, :limit => 3, :order => "created_at DESC")
  end
end
