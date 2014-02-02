class PromptsController < ApplicationController
  before_filter :authenticate_adminuser!, :only => [:admin_index, :create, :edit, :update, :destroy]

  def index
    @prompts = Prompt.where("opendate < ?", DateTime.now).order(:opendate).reverse_order
  end

  def admin_index
    @prompts = Prompt.order(:opendate).reverse_order
    @prompt = Prompt.new
  end

  def show
    @prompt = Prompt.find(params[:id])
    @stories = Story.where(:prompt_id => @prompt.id).sort {|a, b| a.prompt_votes(@prompt).count <=> b.prompt_votes(@prompt).count}

    # The number of votes a user has left for this prompt
    @user_vote_count = 3 - PromptVote.where(:prompt_id => @prompt.id, :user_id => current_user.id).count
  end

  def create
    @prompt = Prompt.new(params[:admins_prompt])

    if @prompt.save
      redirect_to admins_prompts_path, notice: "Prompt was successfully scheduled."
    else
      redirect_to admins_prompts_path, notice: "Something went wrong while saving your prompt. Please try again."
    end
  end

  def edit
    @prompt = Prompt.find(params[:id])
  end

  def update
    @prompt = Prompt.find(params[:id])
    if @prompt.update_attributes(params[:admins_prompt])
      redirect_to admins_prompts_path, notice: "Prompt was successfully updated."
    else
      redirect_to admins_edit_prompt_path(@prompt), notice: "Something went wrong while saving your prompt. Please try again."
    end
  end

  def destroy
    @prompt = Prompt.find(params[:id])
    if @prompt.destroy
      redirect_to admins_prompts_path, notice: "Prompt was successfully deleted."
    else
      redirect_to admins_prompts_path, notice: "Something went wrong while deleting your prompt. Please try again."
    end
  end
end
