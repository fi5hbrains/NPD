class Brand < ActiveRecord::Base
  include Slugify
  
  before_validation :name_to_slug

  validates :slug, uniqueness: true, presence: true
  
  has_many :collections,         dependent: :destroy
  has_many :polishes,            dependent: :destroy
  has_many :bottles,             dependent: :destroy
  has_many :synonyms, as: :word, dependent: :destroy

  def synonym_list; self.synonyms.map(&:name).try(:join, '; ')  end
  def synonym_list=(names)    
    self.synonyms = names.split(';').map{|n| Synonym.where(word_type: 'Brand', word_id: self.id, name: n.strip).first_or_create!} 
  end 
  
  def folder; "/assets/brands/#{self.slug}" end
  
  scope :sort_by_polishes_count, -> { order(polishes_count: :DESC) }

  def to_param; slug end
  
  def name_to_slug
    unless self.name.squish!.empty?
      self.slug = slugify(self.name)
    end
  end  
  
end
