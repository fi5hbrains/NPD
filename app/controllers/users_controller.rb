class UsersController < ApplicationController
  include Slugify
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:preview]
      @user.assign_attributes(user_params)
      render :edit
    elsif params[:cancel]
      @user.assign_attributes(user_params.except(:avatar, :avatar_cache))
      render :edit
    else
      if @user.update(user_params) 
        unless params[:user][:avatar_cache].blank? && params[:user][:avatar].blank?
          @user.avatar.big_thumb.crop_and_resize(params[:user][:crop_coords])
          @user.avatar.thumb.resize(@user.avatar.big_thumb)
        end
        redirect_to @user, notice: 'User was successfully updated.' 
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def vote
    if current_user
      vote = current_user.votes.find_or_initialize_by(params.permit(:votable_type, :votable_id))
      old_vote = vote.new_record? ? 0 : vote.rating
      vote.rating = params[:vote] == 'up' ? 1 : params[:vote] == 'down' ? -1 : params[:vote].to_i < 1 ? 1 : params[:vote].to_i > 5 ? 5 : params[:vote].to_i
      
      case params[:votable_type]
      when 'Polish'
        vote.save
        (@polish = Polish.find(params[:votable_id])).calculate_rating
      when 'Comment'
        unless (@comment = Comment.find params[:votable_id]).user_id == current_user.id || old_vote == vote.rating
          @comment.rating += vote.rating
          @comment.save 
          vote.rating = 0 if (old_vote == 1 && vote.rating == -1) || (old_vote == -1 && vote.rating == 1)
          vote.save unless @comment.user_id == current_user.id
        end
      end
    end
  end

  def get_invite    
    @invite = Invite.give_to current_user if current_user
  end
  
  private
    def set_user
      @user = User.find_by_slug(slugify(params[:user_id]))
    end

    def user_params
      params.require(:user).permit(:name, :password, :invite_phrase, :about, :avatar, :crop_coords, :remove_avatar, :remote_avatar_url, :avatar_cache, :email, :role, :locale )
    end
end
