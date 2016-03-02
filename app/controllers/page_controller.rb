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
        @status = 'say invites only'
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
          @status = 'wrong passphrase'
          @shake = true
        end
      end
    end
  end
  
  def maintenance
    @result = 'wrong user, sorry'
    if current_user && current_user.name == 'bobin'
      @result = 0
      Brand.where(polishes_count: 0).each(&:destroy)
      sheet = Roo::Spreadsheet.open(Rails.root.join('public').to_s + '/brands.xlsx')
      (1..sheet.last_row).each do |i|
        names = sheet.row(i)[0].to_s.gsub('.0','')
        link = sheet.row(i)[1]
        unless Brand.where(name: names.split(';')[0].squish.strip).count > 0
          brand = Brand.new
          brand.synonym_list = names
          brand.link = link
          brand.user_id = current_user.id
          brand.name = names.split(';')[0].try(:strip)
          brand.save
          @result += 1
        end
      end
    end
  end
end
