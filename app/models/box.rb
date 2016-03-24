# encoding: utf-8
class Box < ActiveRecord::Base
  include Slugify

  before_validation :name_to_slug
  
  belongs_to :user
  has_many :box_items, dependent: :destroy
  has_many :polishes, through: :box_items
  
  validates :slug, uniqueness: {scope: :user_id, message: 'already exists for this user', :case_sensitive => false }, :allow_blank => false

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
  
  def export_csv(bottle = false, nail = false, rating = false, note = false)
    CSV.generate do |csv|
      headers = %w(brand name number colour notes).map{|h| I18n.t('sheet.' + h)}
      csv << headers
      self.polishes.each do |p|
        csv << [p.brand_name, p.name, p.number, ("hsl(#{p.h},#{p.s},#{p.l})" if p.h)]
      end
    end
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