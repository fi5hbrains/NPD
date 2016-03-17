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
      agent = Mechanize.new
      brand = Brand.find_by_slug('picture-polish')      
      page = agent.get 'http://www.picturepolish.com.au/index.php?route=product/category&path=142&limit=100'
      shades = page.at('.product-grid').search('.span3')
      
      shades.each do |shade|
        shade = shade.at('img')
        polish = brand.polishes.where(name: shade.attr('alt').gsub(' Nail Polish', '')).first_or_create
        if polish.new_record? 
          polish.synonym_list = polish.name
          polish.brand_slug = brand.slug
          polish.brand_name = brand.name
        end        
        polish.user_id = current_user.id
        polish.remote_reference_url = shade.attr('src')
        polish.draft = true
        @result += 1 if polish.save  
      end
      
      # Polish.where(brand_slug: 'barry-m').where('coats_count != 0').each{|p| p.draft = false; p.save; @result += 1}
      # ------------- Barry M
      # brand = Brand.find_by_slug('barry-m')
      # ["https://www.barrym.com/product/Classic","https://www.barrym.com/product/Sunset-Gel","https://www.barrym.com/product/Gelly-Hi-Shine","https://www.barrym.com/product/Speedy","https://www.barrym.com/product/Matte","https://www.barrym.com/product/Aquarium","https://www.barrym.com/product/Glitterati"].each do |link|
      #   page = agent.get link
      #   shades = page.at('.col-sm-8').search('li')
      #   shades.each do |shade|
      #     polish = brand.polishes.where(name: shade.attr('data-rangename')).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = shade.attr('data-rangename')
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #     end
      #     polish.user_id = current_user.id
      #     polish.remote_reference_url = 'https://www.barrym.com' + shade.at('img').attr('src').gsub('small.jpg','zoom.jpg')
      #     polish.draft = true
      #     @result += 1 if polish.save
      #   end
      # end
      
      # ----------------- china glaze
      # 6.times do |i|
      #   brand = Brand.find_by_slug('china-glaze')
      #   page = agent.get 'http://chinaglaze.com/Colour/China-Glaze-Lacquer/pageNum_' + i.to_s + '.html'
      #   shades = page.at('#color_dot').search('.bottle')
      #   shades.each do |shade|
      #     polish = brand.polishes.where(name: (name = shade.at('#color-name').text)).first_or_create
      #     if polish.new_record? 
      #       polish.name = name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #     end
      #     polish.user_id = current_user.id
      #     polish.remote_reference_url = 'http://chinaglaze.com' + shade.at('img').attr('src')
      #     polish.draft = true
      #     @result += 1 if polish.save
      #   end
      # end
      
      # ----------------- CHANEL
      # brand = Brand.find_by_slug('chanel')
      # agent = Mechanize.new
      # page = agent.get 'http://www.chanel.com/en_GB/fragrance-beauty/makeup/nails/nail-colour/le-vernis-nail-colour-p128000.html'
      # shades = page.at('.fnb_shades_container').search('.fnb_shade')
      # shades.each do |shade|
      #   polish = brand.polishes.where(number: shade.attr('title').to_i).first_or_create
      #   if polish && (polish.new_record? || polish.draft)
      #     if polish.new_record? 
      #       polish.number = shade.attr('title').to_i
      #       polish.name = (name = shade.attr('title').split(' - ')[1])[0] + name[1..-1].mb_chars.downcase
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #     end
      #     polish.remote_reference_url = shade.attr('data-shade')
      #     layer = polish.layers.find_by_layer_type('base')
      #     layer ||= polish.layers.new(layer_type: 'base')
      #     layer.c_base = shade.attr('data-dcext-ch_sha')
      #     polish.user_id = current_user.id
      #     @result += 1 if polish.save
      #   end
      # end
      
      # --------------- import brands
      # Brand.where(polishes_count: 0).each(&:destroy)
      # sheet = Roo::Spreadsheet.open(Rails.root.join('public').to_s + '/brands.xlsx')
      # (1..sheet.last_row).each do |i|
      #   names = sheet.row(i)[0].to_s.gsub('.0','')
      #   link = sheet.row(i)[1]
      #   unless Brand.where(name: names.split(';')[0].squish.strip).count > 0
      #     brand = Brand.new
      #     brand.synonym_list = names
      #     brand.link = link
      #     brand.user_id = current_user.id
      #     brand.name = names.split(';')[0].try(:strip)
      #     brand.save
      #     @result += 1
      #   end
      # end
    end
  end
end
