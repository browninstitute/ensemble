class PostsController < ApplicationController
  impressionist
  load_and_authorize_resource
  layout "stories"

  def index
    @story = Story.find(params[:story_id])
    @posts = Post.ordered_posts(params[:story_id])

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

    @post.mark_thread_as_read! current_user

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
      @post.mark_as_read! :for => current_user # should not be unread by its creator
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
    @post = Post.find(params[:id])

    if @post.destroy
      respond_to do |format|
        format.js
      end
    end
  end
end
