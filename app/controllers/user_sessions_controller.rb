class UserSessionsController < ApplicationController  
  def new
    @user = User.new
  end

  def create
    @user_session = UserSession.new params.require(:user).permit(:name, :password)
    if @user_session.save
      redirect_to @user, notice: 'lalala'
    else
      @user = User.new params.require(:user).permit(:name, :password)
      render 'page/index'
    end
  end
  
  def switch
    cookies[params[:switch]] = params[:option]
    logger.debug params[:switch] + ': ' + cookies[params[:switch]]
    if params[:switch] == 'polish_sort'
      respond_to do |format|
        format.html { redirect_to :back}
        format.js { redirect_to '/reorder?' + env["HTTP_REFERER"].split('?')[1].to_s }
      end
    else
      redirect_to :back
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, notice: 'logged out'
  end
end  