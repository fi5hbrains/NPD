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
    ref_params = env["HTTP_REFERER"].split('?')[1].to_s
    if params[:switch] == 'polish_sort'
      respond_to do |format|
        format.html { redirect_to :back}
        format.js { redirect_to '/reorder?' +  ref_params}
      end
    # elsif params[:switch] == 'box_sort'
    #   respond_to do |format|
    #     format.html { redirect_to :back}
    #     format.js { redirect_to '/collection_search?' + ref_params + (ref_params ? '&' : '') + 'box_id=' + params[:box_id]  + '&filter_brand=' + params[:filter_brand] }
    #   end
    else
      redirect_to :back
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, notice: 'logged out'
  end
end  