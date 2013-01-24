class ParagraphsController < ApplicationController

  # Toggle likes on a paragraph
  def like
    @para = Paragraph.find(params[:id])
    
    if current_user.voted_up_on? @para
      @para.disliked_by current_user
    else
      @para.liked_by current_user
    end

    respond_to do |format|
      format.js
    end
  end

end