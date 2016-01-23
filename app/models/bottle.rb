class Bottle < ActiveRecord::Base
  belongs_to :brand
  
  mount_uploaders :layers, LayerUploader

  validates :user_id, presence: true
  
  def bottle_folder; "assets/brands/#{self.brand_slug}/bottles/#{self.id.to_s}" end
  def highlight_url;  '/' + self.bottle_folder + '/screen.png' end
  def shadow_url;     '/' + self.bottle_folder + '/multiply.png' end
  def mask_url;       '/' + self.bottle_folder + '/mask.png' end
  def base_url;       '/' + self.bottle_folder + '/base.png' end
  def base_thumb_url; '/' + self.bottle_folder + '/thumb_base.png' end
  
end