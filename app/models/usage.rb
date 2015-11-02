class Usage < ActiveRecord::Base
  default_scope { order(ordering: :ASC) }  
  
  belongs_to :entry
  belongs_to :polish, counter_cache: true
  
end