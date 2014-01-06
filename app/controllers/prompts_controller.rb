class PromptsController < ApplicationController
  before_filter :authenticate_adminuser!

  def index
    @prompts = Prompt.where("opendate < ?", DateTime.now).order(:opendate).reverse_order
  end

  def admin_index
    @prompts = Prompt.order(:opendate).reverse_order
    @prompt = Prompt.new
  end

  def show
    @prompt = Prompt.find(params[:id])
    @stories = Story.where(:prompt_id => @prompt.id)
  end

  def create
    @prompt = Prompt.new(params[:prompt])

    if @prompt.save
      redirect_to admins_prompts_path, notice: "Prompt was successfully scheduled."
    else
      redirect_to admins_prompts_path, ntoice: "Something went wrong while saving your prompt. Please try again."
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
