class BoxItem < ActiveRecord::Base
  belongs_to :box, counter_cache: true
  belongs_to :polish  
end