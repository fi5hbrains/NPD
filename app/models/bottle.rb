class Bottle < ActiveRecord::Base
  belongs_to :brand
  
  mount_uploaders :layers, LayerUploader

  validates :user_id, presence: true

  def highlight_url;  "/assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}/screen.png" end
  def shadow_url;     "/assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}/multiply.png" end
  def mask_url;       "/assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}/mask.png" end
  def base_url;       "/assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}/base.png" end
  def base_thumb_url; "/assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}/thumb_base.png" end
  
end