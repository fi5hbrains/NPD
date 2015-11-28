# encoding: utf-8
class Box < ActiveRecord::Base
  include Slugify

  before_validation :name_to_slug
  
  belongs_to :user
  has_many :box_items, dependent: :destroy
  has_many :polishes, through: :box_items
  
  validates :slug, uniqueness: {scope: :user_id, message: 'already exists for this user', :case_sensitive => false }, :allow_blank => false

  def open_spreadsheet(file)
    Roo::Spreadsheet.open(file.path, extension: File.extname(file.path))
  end
  def import(file)
    spreadsheet = open_spreadsheet(file)
    header = self.rename_header_columns(spreadsheet.row(1))
    items = self.box_items
    stats = {added: 0, new: 0, failed: 0, unknown: Set.new}
    brands = Set.new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unless !row['brand'] || row['brand'].empty?
        ids = Synonym.where("name ilike ? AND word_type = 'Brand'", "#{row['brand'].to_s.squeeze.strip}%").pluck('word_id')
        brand = Brand.find(ids.first) unless ids.empty?
        if brand
          name = row['polish'].to_s
          number = row['number'].to_s.squeeze.strip
          polish = (Polish.where(brand_id: brand.id, slug: slugify(name || number)).first || Polish.new)
          if polish.new_record?
            polish.draft = true
            polish.name = name unless name.blank?
            polish.number = number.gsub(/\.0$/, '') unless number.blank? || number.mb_chars.downcase == 'n/a'
            polish.brand_id = brand.id
            polish.brand_name = brand.name
            polish.brand_slug = brand.slug
            polish.user_id = self.user_id
            polish.save
            stats[:new] += 1
            brands << brand
          end
        else
          stats[:failed] += 1
          stats[:unknown] << row['brand']
        end
        if polish && polish.id
          item = items.find_by_polish_id(polish.id) || self.box_items.new(polish_id: polish.id).save
          stats[:added] += 1
        end
      end
    end
    self.import_result = "#{stats[:added]};#{stats[:new]};#{stats[:failed]};#{stats[:unknown].to_a.join(', ')}"
    self.save
    for b in brands
      b.drafts_count = b.polishes.where(draft: true).count
      b.save
    end
    return stats
  end
  # handle_asynchronously :import
  
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