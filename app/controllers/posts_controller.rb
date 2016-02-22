class PostsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like]
  before_action :owned_post, only: [:edit, :update, :destroy]


  def upvote
    @post = Post.find(params[:id])
    @post.liked_by current_user
    redirect_to @post
  end


  def index
    @page = (params[:page] || 1).to_i
    offset = (@page - 1) * 25

    @posts = Post.order(created_at: :desc).limit(25).
    offset(offset).all
  end

  def trend
    @posts = Post.highest_voted
  end


  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to posts_path
    else
      flash[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
    end
  end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to posts_path
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def owned_post
    unless current_user == @post.user
      flash[:alert] = "Not Allowed!"
      redirect_to root_path
    end
  end

  def post_params
    params.require(:post).permit(:image, :caption)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
