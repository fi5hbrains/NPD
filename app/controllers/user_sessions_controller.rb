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
    respond_to do |format|
      format.html { redirect_to :back}
      format.json { redirect_to '/search?' + env["HTTP_REFERER"].split('?')[1] }
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, notice: 'logge out'
  end
end  