class CommentsController < ApplicationController

  def create
    (@comment = current_user.comments.new(comment_params)).save
  end
  
  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes(comment_params)
  end
  
  def destroy
    @comment = Comment.find(params[:id]).try(:destroy)
  end
  
  private

  def comment_params
    params.require(:comment).permit(:commentable_type, :commentable_id, :body).merge(user_name: current_user.name)
  end
  
end