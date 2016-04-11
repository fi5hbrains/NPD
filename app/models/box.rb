# encoding: utf-8
class Box < ActiveRecord::Base
  include Slugify, ColourMethods

  before_validation :name_to_slug
  
  belongs_to :user
  has_many :box_items, dependent: :destroy
  has_many :polishes, through: :box_items
  
  validates :slug, uniqueness: {scope: :user_id, message: 'already exists for this user', :case_sensitive => false }, :allow_blank => false
  
  EXPORT_OPTIONS = {
    'csv' => {'colour' => true, 'note' => true, 'rating' => true},
    'xlsx' => {'colour' => true, 'bottle' => false, 'nail' => false, 'note' => true, 'rating' => true},
    'image' => {'bottle' => true, 'nail' => false, 'note' => true, 'rating' => false, 'bg_colour' => '#fff', 'columns' => 7}
  }

  def import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path, extension: File.extname(file.path))
    header = self.rename_header_columns(spreadsheet.row(1))
    items = self.box_items
    stats = {total: 0, added: 0, new: 0, failed: 0, unknown: Set.new}
    brands = Set.new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unless !row['brand'] || row['brand'].empty?
        ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "#{row['brand'].to_s.squeeze.strip}%").pluck('word_id')
        brand = Brand.find(ids.first) unless ids.empty?
        if brand
          name = row['polish'].to_s.squeeze.strip
          number = row['number'].to_s.squeeze.strip
          polish = (Polish.where(brand_id: brand.id, slug: slugify(name || number)).first || Polish.new)
          if polish.new_record?
            polish.draft = true
            unless name.blank?
              polish.name = name 
              polish.synonyms.new(name: name)
            end
            polish.number = number.gsub(/\.0$/, '') unless number.blank? || number.mb_chars.downcase == 'n/a'
            polish.brand_id = brand.id
            polish.brand_name = brand.name
            polish.brand_slug = brand.slug
            polish.user_id = self.user_id
            puts polish.inspect
            polish.save
            stats[:new] += 1
            brands << brand
          end
        else
          stats[:failed] += 1
          stats[:unknown] << row['brand']
        end
        if polish && polish.id
          unless items.find_by_polish_id(polish.id)
            self.box_items.new(polish_id: polish.id).save
            stats[:added] += 1
          end
          stats[:total] += 1
        end
      end
    end
    stats[:unknown] = stats[:unknown].to_a[0..-1].join(', ') + ' and ' + stats[:unknown].to_a.last if stats[:unknown].size >= 2
    self.import_result = "#{stats[:total]};#{stats[:added]};#{stats[:new]};#{stats[:failed]};#{stats[:unknown]}"
    self.save
    for b in brands
      b.drafts_count = b.polishes.where(draft: true).count
      b.save
    end
    return stats
  end
  
  def export_image bg = 'transparent', columns = 4, note = false, bottle = false, nail = false
    path = Rails.root.join('public').to_s
    output_folder = "/downloads/#{self.user_id}"
    FileUtils.mkdir_p(path + output_folder) unless File.directory?(path + output_folder)    
    row_items = []
    rows = []
    stack = ''
    (polishes = self.polishes).each_with_index do |polish,index|
      row_items << polish
      if ((index + 1).modulo(columns) == 0 ) || index == (polishes.size - 1)
        row_items.reverse.each_with_index do |p,i|
          if bottle && nail
            stack += " \\( #{path + (p.draft ? '/assets/draft.png' : p.bottle_url)} -geometry +#{(row_items.size - i - 1) * 360}+#{p.draft ? 92 : 0} \\) -composite "
            stack += " \\( #{path + '/assets/preview_shadow.png'} -geometry 145x290+#{(row_items.size - i - 1) * 360 + 210}+82 \\) -composite "
            stack += " \\( #{path + p.preview_url} -geometry 155x290+#{(row_items.size - i - 1) * 360 + 205}+82 \\) -composite " unless p.draft
            if note
              stack += " \\( -size 310 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 360 + 35}+377 \\) -composite "              
            else
              stack += " \\( -size 310 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 360 + 35}+377 \\) -composite "
            end
          elsif bottle
            stack += " \\( #{path + (p.draft ? '/assets/draft.png' : p.bottle_url)} -geometry +#{(row_items.size - i - 1) * 250}+#{p.draft ? 92 : 0} \\) -composite "
            if note
              stack += " \\( -size 240 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 250 + 5}+377 \\) -composite "              
            else
              stack += " \\( -size 240 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 250 + 5}+377 \\) -composite "
            end
          elsif nail
            stack += " \\( #{path + '/assets/preview_shadow.png'} -geometry 186x372+#{(row_items.size - i - 1) * 250 + 28}+60 \\) -composite "
            stack += " \\( #{path + p.preview_url} -geometry +#{(row_items.size - i - 1) * 250 + 22}+60 \\) -composite " unless p.draft
            if note
              stack += " \\( -size 240 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 250 + 1}+442 \\) -composite "              
            else
              stack += " \\( -size 240 -gravity center -background transparent  pango:\"<span  size='23000' face='PT Sans Narrow'>#{p.brand_name}\\n#{!p.number.blank? && !p.name.blank? ? p.number + ' <b>' + p.name + '</b>' : !p.number.blank? ? p.number : '<b>' + p.name + '</b>'}</span>\" -gravity NorthWest -geometry +#{(row_items.size - i - 1) * 250 + 1}+442 \\) -composite "
            end
          else

          end
        end
        row = "row_#{(index / columns ).to_i}.png"
        rows << row
        if bottle && nail
          Magick.convert " -size #{columns * 360}x590 canvas:transparent ", stack, output_folder + '/' + row
        elsif bottle
          Magick.convert " -size #{columns * 250}x590 canvas:transparent ", stack, output_folder + '/' + row
        elsif nail
          Magick.convert " -size #{columns * 250}x590 canvas:transparent ", stack, output_folder + '/' + row
        else
          
        end

        stack = ''
        row_items = []
      elsif index.modulo(columns) != 0
      end
    end
    stack = ''
    rows.each_with_index do |row,i|
      if !bottle && nail
        stack += " #{path + output_folder}/#{row} -geometry +10+#{i * 525} -composite "
      else
        stack += " #{path + output_folder}/#{row} -geometry +10+#{i * 430} -composite "
      end
    end
    if bottle && nail
      Magick.convert "-size #{columns * 360 + 50}x#{rows.size * 430 + 130} canvas:'#{bg}'", stack, output_folder + '/' + self.slug + '.png'
    elsif bottle
      Magick.convert "-size #{columns * 250}x#{rows.size * 430 + 130} canvas:'#{bg}'", stack, output_folder + '/' + self.slug + '.png'
    elsif nail
      Magick.convert "-size #{columns * 250 + 10}x#{rows.size * 525 + 130} canvas:'#{bg}'", stack, output_folder + '/' + self.slug + '.png'
    else
      
    end
  end
  
  def export_csv colour = true, bottle = false, nail = false, note = true, rating = true, user_id
    CSV.generate do |csv|
      headers = %w(brand name colour rating notes).map{|h| I18n.t('sheet.' + h)}
      csv << headers
      self.polishes.each do |p|
        name_or_number = !p.name.blank? ? !p.number.blank? ? (p.name + ' - ' + p.number) : p.name : p.number 
        colour = get_colour_names([p.h,p.s,p.l]).last
        csv << [p.brand_name, name_or_number, colour]
      end
    end
  end
  
  def export_xlsx colour = true, bottle = false, nail = false, note = true, rating = true, user_id
    path = Rails.root.join('public').to_s
    output_folder = "/downloads/#{self.user_id}"
    FileUtils.mkdir_p(path + output_folder) unless File.directory?(path + output_folder)    
    headers = %w(brand name colour rating notes).map{|h| I18n.t('sheet.' + h)}
    package = Axlsx::Package.new
    package.workbook.add_worksheet(:name => self.user.slug + '_' + self.slug) do |sheet|
      heading = sheet.styles.add_style(alignment: {horizontal: :center, vertical: :center}, b: true, sz: 18)
      imaged = sheet.styles.add_style(height: 50)
      sheet.add_row headers, style: heading, height: 30
      color_cell_styles = []
      self.polishes.each_with_index do |p,i|
        name_or_number = !p.name.blank? ? !p.number.blank? ? (p.name + ' - ' + p.number) : p.name : p.number 
        colour_name = get_colour_names([p.h,p.s,p.l]).last
        fg_colour = (p.l.blank? || p.l > 50) ? '000000' : 'FFFFFF' 
        link = 'http://i-n-p-d.com/catalogue/' + p.brand_slug + '/' + p.slug
        img = path + (p.draft ? '/assets/' : '') + p.bottle_url('thumb')
        if p.h
          color_cell_styles << sheet.styles.add_style(bg_color: hsl_to_rgbhex(p.h,p.s,p.l), fg_color: fg_colour, alignment: {horizontal: :center})
          sheet.add_row [p.brand_name, name_or_number, colour_name], style: [nil, nil, color_cell_styles.last], types: [nil, :string]
        end
        sheet.add_hyperlink :location => link, :ref => sheet.rows.last.cells[1]
      end
    end
    package.use_shared_strings = true
    package.serialize("public/downloads/#{self.user_id}/#{self.slug}.xlsx")
  end
  
  def rename_header_columns(header)
    brand = false
    polish = false
    number = false
    brands = ['brand', 'brand name','фирма','марка', 'брэнд', 'бренд']
    polishes = ['color name', 'colour name','color','colour', 'name', 'polish', 'lacquer', 'наименование', 'название', 'имя', 'лак']
    numbers = ['number', 'номер']
    header.each_with_index do |col, i|
      if col && !brand && brands.include?(col.to_s.squeeze.strip.mb_chars.downcase) 
        header[i] = 'brand'
        brand = true
      elsif col && !polish && polishes.include?(col.to_s.squeeze.strip.mb_chars.downcase) 
        header[i] = 'polish'
        polish = true
      elsif col && !number && numbers.include?(col.to_s.squeeze.strip.mb_chars.downcase) 
        header[i] = 'number'
        number = true
      end
    end
    if !brand
      raise "Couldn't find the Brands column"
    elsif !polish
      raise "Couldn't find the Colour Names column"
    else
      return header
    end
  end
  
  def to_param; slug end
  
  def name_to_slug
    unless self.name.squish!.empty?
      self.slug = slugify(self.name)
    end
  end  
  
  def adapt_name; %w(collection wishlist giveaway).include?(self.name) ? I18n.t('user.list.' + self.name) : self.name end
  
end