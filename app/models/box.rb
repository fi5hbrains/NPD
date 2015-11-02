# encoding: utf-8
class Box < ActiveRecord::Base
  include Slugify

  before_validation :name_to_slug
  
  belongs_to :user
  has_many :box_items, dependent: :destroy
  has_many :polishes, through: :box_items
  
  validates :slug, uniqueness: {scope: :user_id, message: 'already exists for this user', :case_sensitive => false }, :allow_blank => false
  
  def to_param; slug end
  
  def name_to_slug
    unless self.name.squish!.empty?
      self.slug = slugify(self.name)
    end
  end  
  
  def adapt_name; %w(collection wishlist giveaway).include?(self.name) ? I18n.t('user.list.' + self.name) : self.name end
  
end