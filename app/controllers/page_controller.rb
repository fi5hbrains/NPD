# encoding: utf-8
class PageController < ApplicationController
  include Slugify
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
            @focus = 'keep'
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

      brand = Brand.find_by_slug('opi')
      brand.polishes.where("name ilike '%...%' OR name ilike '%''%'").each do |p_a|
        p_b = brand.polishes.find_by_slug(p_a.slug.gsub('... ', '…').gsub('...','…').gsub("'",'’'))
        p_b ||= brand.polishes.new(slug: p_a.slug.gsub('... ', '…').gsub('...','…').gsub("'",'’'))
        if p_a.draft
          if p_b 
            p_b.collection = p_a.collection if p_b.collection.blank?
            p_b.release_year = p_a.release_year if p_b.release_year.blank? || p_b.release_year == 0
            p_b.synonym_list = p_a.name.gsub('... ', '…').gsub('...','…').gsub("'",'’') + ';' + p_a.name
            p_b.draft = true if p_b.new_record?
            if p_b.save
              p_a.destroy
              @result += 1
            end
          end
        else
          #alala
        end
      end
      
      # brand = Brand.find_by_slug 'astor'
      # page = agent.get  'http://www.astorcosmetics.com/products/nails/nail-color/color-care'
      # shades = page.search('.node-color')
      # shades.each do |shade|
      #   name = shade.at('h3').at('a').text.split('[')
      #   polish = brand.polishes.where(name: name.first).first_or_create
      #   polish.number = name.last.sub(']','')
      #   if polish.new_record?
      #     polish.prefix = 'splash'
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #   end        
      #   if polish.draft
      #     polish.remote_reference_url = 'http://www.astorcosmetics.com/sites/default/files/public/field_product_col_image/17491-page-web-perfect-stay-cc-nude-02_!!!.png'.sub('!!!', polish.number)
      #     polish.layers.new(layer_type: 'base', c_base: shade.at('.color-swatch').attr('style')[18..24])
      #     @result += 1 if polish.save 
      #   end
      # end
      
      #  brand = Brand.find_by_slug 'illamasqua'
      # page = agent.get 'http://www.illamasqua.com/shop/nails/nail-varnishes/'
      # shades = page.search('.item')
      # shades.each do |shade|
      #   name = shade.at('h4').text
      #   unless name.blank?
      #     polish = brand.polishes.where(name: name).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = polish.name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.draft = true
      #     end
      #     if polish.draft?
      #       polish.remote_reference_url = shade.at('.product-image').attr('onmouseover').sub("this.src='",'').sub("';",'')
      #       @result += 1 if polish.save 
      #     end        
      #   end
      # end      
      
      # agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
      # brand = Brand.find_by_slug 'christian-dior'
      # page = agent.get 'http://www.dior.com/beauty/en_us/fragrance-beauty/makeup/nails/nail-lacquers/dior-vernis/pr-diorvernis-y0002959-couturecolorgelshinelongwearnaillacquer.html'
      # shades = page.search('.js-swatch-hover')
      # shades.each do |shade|
      #   name = shade.at('img').attr('alt').split(' - ')
      #   polish = brand.polishes.where(name: name.last).first_or_create
      #   if polish.new_record? 
      #     polish.number = name.first
      #     polish.synonym_list = polish.name unless polish.name.blank?
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #   end
      #   if polish.draft?
      #     polish.remote_reference_url = 'http://www.dior.com' + shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end      
      # brand = Brand.find_by_slug 'inglot'
      # ['o2m.breathable.nail.enamel/products/141/1511','o2m.breathable.nail.enamel.soft.matte/products/141/1982','nail.enamel/products/141/1512','nail.enamel.dream/products/141/1513','nail.enamel.matte/products/141/1514'].each do |link|
      #   page = agent.get  'http://inglotcosmetics.com/' + link
      #   shades = page.search('.product-color-item')
      #   shades.each do |shade|
      #     number = shade.at('span').text
      #     polish = brand.polishes.where(number: number).first_or_create
      #     if polish.new_record? 
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.draft = true
      #     end        
      #     if polish.draft
      #       polish.remote_reference_url = 'http://inglotcosmetics.com' + shade.at('img').attr('src')
      #       @result += 1 if polish.save 
      #     end
      #   end
      # end
      
      # ----------------------'Julep'
      # brand = Brand.find_by_slug 'julep'
      # 28.times do |i|
      #   page = agent.get 'http://www.julep.com/nail/polish.html?page=' + (i + 1).to_s
      #   shades = page.search('h5')
      #   shades.each do |shade|
      #     name = shade.at('.name').text
      #     polish = brand.polishes.where(name: name).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = polish.name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.bottle_id = 194
      #       polish.draft = true
      #     end        
      #     if polish.draft
      #       polish.collection = shade.at('.product-name').search('div').last.text
      #       polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #       @result += 1 if polish.save 
      #     end
      #   end
      # end
      
      # -------------eleccio
      # brand = Brand.find_by_slug 'eleccio'
      # page = agent.get 'http://eleccio.com/shop/?product_count=200'
      # shades = page.search('li.product')
      # shades.each do |shade|
      #   name = shade.at('.product-title').at('a').text
      #   polish = brand.polishes.where(name: name).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #   end        
      #   if polish.draft
      #     polish.remote_reference_url = shade.at('.hover-image').attr('src')
      #     @result += 1 if polish.save 
      #   end
      # end
      
      # brand = Brand.find_by_slug 'barielle'
      # 8.times do |i|
      #   page = agent.get 'http://www.nailsupplies.us/barielle/?sort=featured&page=' + i.to_s
      #   shades = page.at('.ProductList').search('li')
      #   shades.each do |shade|
      #     name = shade.at('.ProductDetails').at('strong').text.sub('Barielle - ','').sub(' 0.45oz','')
      #     polish = brand.polishes.where(name: name).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = polish.name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.bottle_id = 165
      #       polish.draft = true
      #     end        
      #     if polish.draft
      #       polish.remote_reference_url = shade.at('img').attr('src')
      #       @result += 1 if polish.save 
      #     end
      #   end
      # end
      
      # ------------------------ Kiko      
      # brand = Brand.find_by_slug('kiko-milano')
      # page = agent.get 'http://www.kikocosmetics.com/en-gb/make-up/hands/nail-polishes/Quick-Dry-Nail-Lacquer/p-KM004010018#zoom'
      # shades = page.at('#js-palette').search('.icon-zoom')
      # shades.each do |shade|
      #   name = shade.at('.only-smart').at('span').text
      #   polish = brand.polishes.where(name: name[3..-1]).first_or_create
      #   if polish.new_record? 
      #     polish.number = name[0..2]
      #     polish.synonym_list = polish.name
      #     polish.bottle_id = 160
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      # page = agent.get 'http://www.kikocosmetics.com/en-gb/make-up/hands/nail-polishes/Nail-Lacquer/p-KM00401001'
      # shades = page.at('#js-palette').search('.icon-zoom')
      # shades.each do |shade|
      #   name = shade.at('.only-smart').at('span').text
      #   polish = brand.polishes.where(name: name[3..-1]).first_or_create
      #   if polish.new_record? 
      #     polish.number = name[0..2]
      #     polish.synonym_list = polish.name
      #     polish.bottle_id = 82
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end      
      # page = agent.get 'http://www.kikocosmetics.com/en-gb/make-up/hands/nail-polishes/Power-Pro-Nail-Lacquer/p-KMPOWER'
      # shades = page.at('#js-palette').search('.icon-zoom')
      # shades.each do |shade|
      #   name = shade.at('.only-smart').at('span').text
      #   polish = brand.polishes.where(name: name[3..-1]).first_or_create
      #   if polish.new_record? 
      #     polish.number = name[0..2]
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end      
      
      # ----------------------- Alessandro
      # agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
      # brand = Brand.find_by_slug 'alessandro-international'
      # page = agent.get 'https://www.alessandro-international.com/b2b_uk_en/nail-polishes/colour-code-4/'
      # shades = page.search('.dot')
      # shades.each do |shade|
      #   name = shade.at('.innerName').text.strip
      #   polish = brand.polishes.where(name: name).first_or_create
      #   if polish.new_record? 
      #     polish.number = shade.at('strong').text
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # brand = Brand.find_by_slug 'orly'
      # (1..5).each do |i|
      #   page = agent.get 'http://www.orlybeauty.com/nail-color/nail-color-by-types/creme.html?p=' + i.to_s
      #   shades = page.search('li.item')
      #   shades.each do |shade|
      #     name = shade.at('.product-name').at('a').text.strip
      #     polish = brand.polishes.where(name: name).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = polish.name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.draft = true
      #       polish.remote_reference_url = shade.at('.product-image').at('img').attr('src').gsub('.jpg','.png').gsub('small_image','swapimage').gsub('_b_','_p_').gsub('lg_web','web')
      #       @result += 1 if polish.save 
      #     end        
      #   end
      # end
      
      #-------------------- https Ciate
      # agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
      # brand = Brand.find_by_slug 'ciaté-london'
      # (1..3).each do |i|
      #   page = agent.get 'https://www.ciatelondon.com/collections/nails?constraint=polish&page=' + i.to_s
      #   shades = page.search('.no_crop_image')
      #   shades.each do |shade|
      #     name = shade.at('.product-title').text.strip
      #     polish = brand.polishes.where(name: name).first_or_create
      #     if polish.new_record? 
      #       polish.synonym_list = polish.name
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #       polish.user_id = current_user.id
      #       polish.draft = true
      #       polish.remote_reference_url = 'http:' + shade.at('.image-swap').search('img').last.attr('src')
      #       @result += 1 if polish.save 
      #     end        
      #   end
      # end
      
      # ------------------ Evixi
      # brand = Brand.find_by_slug 'evixi'
      # page = agent.get 'http://www.evixigel.co.uk/collections/colours?view=listall'
      # shades = page.at('.product-list').search('.product-item')
      # shades.each do |shade|
      #   name = shade.at('.product-title').text.split(' - ').last
      #   polish = brand.polishes.where(name: name).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # ------------------ Gelish
      # brand = Brand.find_by_slug 'gelish'
      # page = agent.get 'http://gelish.com/products/gelish'
      # shades = page.at('#swatches').search 'li'
      # shades.each do |shade|
      #   name = shade.at('.item-name').text.squish
      #   polish = brand.polishes.where(name: name).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.number = shade.at('.item-num').text
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # ---------------- Naillook
      # brand = Brand.find_by_slug 'naillook'
      # page = agent.get 'http://naillook.uk.com/catalog/lak/'
      # shades = page.search '.goods'
      # shades.each do |shade|
      #   name = shade.at('.goods-title-in').text.squish
      #   polish = brand.polishes.where(name: name.gsub(' ' + name.split(' ').last, '')).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.number = name.split(' ').last
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = 'http://naillook.uk.com' + shade.at('.good-hover').at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # ------------ USLU
      # brand = Brand.find_by_slug 'uslu-airlines'
      # page = agent.get 'http://usluairlines.com/c-shop-e/nail_polish_main_line.html'
      # shades = page.search '.item'
      # shades.each do |shade|
      #   polish = brand.polishes.where(name: shade.at('img').attr('alt').split('<br>')[0]).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.draft = true
      #     polish.remote_reference_url = shade.at('img').attr('src')
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # ----------------- NCLA -----
      # brand = Brand.find_by_slug('ncla-los-angeles')
      # ['http://www.shopncla.com/collections/cremes','http://www.shopncla.com/collections/glitters','http://www.shopncla.com/collections/metallics','http://www.shopncla.com/collections/shimmers','http://www.shopncla.com/collections/holographic'].each do |link|
      #   page = agent.get link
      #   shades = page.at('.span9').search('.span3')
      #   shades.each do |shade|
      #     unless shade.at('a').attr('title').blank? 
      #       polish = brand.polishes.where(name: shade.at('a').attr('title')[5..-1]).first_or_create
      #       if polish.new_record? 
      #         polish.synonym_list = polish.name
      #         polish.brand_slug = brand.slug
      #         polish.brand_name = brand.name
      #         polish.user_id = current_user.id
      #         polish.draft = true
      #         polish.remote_reference_url = 'http:' + shade.at('img').attr('src')
      #         @result += 1 if polish.save 
      #       end        
      #     end
      #   end
      # end
      
      # ---------------- essie
      # brand = Brand.find_by_slug('essie')
      # page = agent.get 'http://www.essie.com/Colors.aspx'
      # shades = page.search('.product-wrapper')
      # shades.each do |shade|
      #   polish = brand.polishes.where(name: shade.at('h2').text).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.user_id = current_user.id
      #     polish.layers.new(layer_type: 'base', c_base: shade.at('.bottle').attr('style')[18..-1])
      #     polish.draft = true
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # -------- Update Polish Preview
      # Polish.all.each do |p|
      #   unless p.draft
      #     Magick.convert p.preview_url, "\\( #{path}/assets/polish_parts/preview_mask.png -background white -alpha shape \\) -alpha on -compose DstIn -composite"
      #     @result += 1
      #   end
      # end
      
      # ----------- Zoya reference image fix ----
      # brand = Brand.find_by_slug('zoya')
      # page = agent.get 'http://www.zoya.com/content/category/Zoya_Nail_Polish.html'
      # brand.polishes.each do |polish|
      #   if polish.draft
      #     shade = page.at('#' + polish.number)
      #     polish.remote_reference_url = 'http:' + shade.at('img').attr('src').gsub('450','452')
      #     polish.save
      #   end
      # end
      
      # -------------- OPI ---------
      # brand = Brand.find_by_slug('opi')
      # page = agent.get 'http://opi.com/color/nail-lacquer#filter=*'
      # shades = page.at('.grid').search('.large-3')
      # shades.each do |shade|
      #   polish = brand.polishes.where(name: shade.at('h3').text).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.number = shade.at('.lacquer-info').search('span').first.text
      #     polish.collection = shade.at('.lacquer-info').search('span').last.at('a').try(:text)
      #     polish.user_id = current_user.id
      #     if shade.at('.swatchimg').at('img')
      #       polish.remote_reference_url = shade.at('.swatchimg').at('img').attr('src')
      #     else
      #       polish.layers.new(layer_type: 'base', c_base: shade.at('.swatchimg').at('.img-block').attr('style')[11..-1])
      #     end
      #     polish.draft = true
      #     @result += 1 if polish.save 
      #   end        
      # end
      
      # ----------------- fix china glaze
      # brand = Brand.find_by_slug('china-glaze')
      # brand.polishes.each do |polish|
      #   if polish.draft
      #     polish.synonym_list = polish.name
      #     polish.save
      #   end
      # end
      
      # ----------------- fix zoya -----------
      # brand = Brand.find_by_slug('zoya')
      # page = agent.get 'http://www.zoya.com/content/category/Zoya_Nail_Polish.html'
      # brand.polishes.each do |polish|
      #   if polish.draft
      #     shade = page.at('#' + polish.number)
      #     polish.name = shade.at('.item-link').text.inspect.split("\\r\\n\\t\\t\\t\\t\\t\\t")[3]
      #     polish.synonym_list = polish.name
      #     polish.save
      #   end
      # end      
      
      # -------------------- Zoya
      # brand = Brand.find_by_slug('zoya') 
      # page = agent.get 'http://www.zoya.com/content/category/Zoya_Nail_Polish.html'
      # shades = page.search('.item')
      # shades.each do |shade|
      #   polish = brand.polishes.where(name: shade.at('.item-name-1').attr('href')[39..-6].gsub('-',' ')).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #     polish.number = shade.attr('data-partnum')
      #   end        
      #   polish.user_id = current_user.id
      #   polish.remote_reference_url = 'http:' + shade.at('img').attr('src').gsub('450','452')
      #   polish.draft = true
      #   @result += 1 if (polish.save if polish.new_record?)
      # end
      
      # ---------------------- Deborah Lippmann ----------
      # brand = Brand.find_by_slug('deborah-lippmann') 
      # ['http://www.deborahlippmann.com/nail-color/celebrity-shades?___store=default','http://www.deborahlippmann.com/nail-color/specialty?___store=default','http://www.deborahlippmann.com/nail-color/shimmer?___store=default', 'http://www.deborahlippmann.com/nail-color/glitter?___store=default','http://www.deborahlippmann.com/nail-color/sheer?___store=default'].each do |link|
      #   page = agent.get link
      #   shades = page.search('.popup-details-content')
      #   shades.each do |shade|
      #     polish = brand.polishes.where(slug: slugify( shade.at('.product-name').at('h3').text)).first_or_create
      #     if polish.new_record? 
      #       polish.name = polish.synonym_list = shade.at('.product-name').at('h3').text.titleize
      #       polish.brand_slug = brand.slug
      #       polish.brand_name = brand.name
      #     end        
      #     polish.user_id = current_user.id
      #     polish.remote_reference_url = shade.at('img.lazy-popup').attr('data-original')
      #     polish.draft = true
      #     @result += 1 if (polish.save if polish.new_record?)
      #   end
      # end
      
      #---------- Picture Polish -------------
      # brand = Brand.find_by_slug('picture-polish') 
      ## brand.polishes.each(&:destroy)
      # page = agent.get 'http://www.picturepolish.com.au/index.php?route=product/category&path=142&limit=100'
      # shades = page.at('.product-grid').search('.span3')
      # 
      # shades.each do |shade|
      #   shade = shade.at('img')
      #   polish = brand.polishes.where(name: shade.attr('alt').gsub(' Nail Polish', '').gsub('(Reborn)','')).first_or_create
      #   if polish.new_record? 
      #     polish.synonym_list = polish.name
      #     polish.brand_slug = brand.slug
      #     polish.brand_name = brand.name
      #   end        
      #   polish.user_id = current_user.id
      #   polish.remote_reference_url = shade.attr('src')
      #   polish.draft = true
      #   @result += 1 if polish.save  
      # end
      
      # Polish.where(brand_slug: 'barry-m').where('coats_count != 0').each{|p| p.draft = false; p.save; @result += 1}
      # ------------- Barry M -----------
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
