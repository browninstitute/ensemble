class PostsController < ApplicationController
  impressionist

  def index
    @story = Story.find(params[:story_id])
    @posts = Post.where(:story_id => params[:story_id], :ancestry => nil)

    respond_to do |format|
      format.html
    end
  end

  def new
    @story = Story.find(params[:story_id])
    @post = Post.new

    respond_to do |format|
      format.js
    end
  end

  def reply
    @story = Story.find(params[:story_id])
    @post = Post.new
    @post.parent_id = Post.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def show
    @story = Story.find(params[:story_id])
    @post = Post.find(params[:id])
    @new_post = Post.new
    @new_post.parent = @post

    respond_to do |format|
      format.html
    end
  end

  def create
    @story = Story.find(params[:story_id])
    @post = Post.new(params[:post])
    @post.story = @story
    @post.user = current_user

    if @post.save
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    @story = Story.find(params[:story_id])
    @post = Post.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
  end
end
