class FollowingsController < ApplicationController
  def create
    current_user.followeeings.where(followee_id: params[:user_id]).first_or_create unless current_user.id == params[:user_id]
    redirect_to :back, notice: 'following'    
  end
  
  def destroy
    current_user.followeeings.where(followee_id: params[:user_id]).first.try(:destroy)
    redirect_to :back, notice: "stopped following"
  end
end