class HomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    puts current_user.inspect
  end

end
