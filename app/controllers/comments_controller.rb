class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      flash[:success] = "Thanks for the love!"
      redirect_to @post
    else
      flash[:alert] = "You missed something!"
      render root_path
    end
  end

  def destroy
  @comment = @post.comments.find(params[:id])

  @comment.destroy
  flash[:success] = "Fine, Take It Back!"
  redirect_to @post
end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

end
