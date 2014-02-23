require 'arrowhead'

class PagesController < ApplicationController
  def about
  end

  def arrowhead
    @stories = Arrowhead.stories
  end
end
