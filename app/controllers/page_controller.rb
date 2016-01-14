class PageController < ApplicationController
  def index
    @status = 'stare'
    @user = params[:user] ? User.new(params.require(:user).permit(:name, :password, :invite_phrase, :avatar)) : User.new
    @focus = 'user_name'
    @submit_text = t('form.enter')
    @button_name = 'submit'
    @shake = false
    if (p = params[:user]) && p[:name].present?
      if p[:name]
        if @suspect = User.find_by_name(p[:name])
          @submit_text = t('form.login')
          # @focus = 'user_password'
          @button_name = 'submit'
        else
          @focus = (params[:active] == 'null' ? 'user_password' : 'user_name')
          @submit_text = t('form.signup')
          @button_name = 'preview'
        end
      end
    end
    if params[:preview]
      @user.valid?
      if @shake = (@user.errors[:name].present? || @user.errors[:password].present?)
        @status = 'explain error'
        @focus = (@user.errors[:password].present? ? 'user_password' : 'user_name')
      else
        @status = 'say important'
        @focus = 'user_invite_phrase'
        @button_name = 'submit'
      end
    elsif params[:submit]
      if @suspect
        @user_session = UserSession.new params.require(:user).permit(:name, :password)
        if @user_session.save
          render js: "window.location.href = '#{user_path(@suspect)}'"
        else
          @status = 'explain error'
          @shake = true
        end
      else
        if @user.save
          # render js: "window.location.href = '#{edit_user_path(@user)}'"
          render js: "window.location.href = '#{user_path(@user)}'"
        else
          @status = 'explain error'
          @shake = true
        end
      end
    end
  end
  
  private

end
