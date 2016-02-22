class ProfilesController < ApplicationController
  def show
    @posts = User.find_by(user_name: params[:user_name]).posts.order('created_at DESC')
    @user = User.find_by(user_name: params[:user_name])
  end

  def profile

  @posts = current_user.posts

  end
end
