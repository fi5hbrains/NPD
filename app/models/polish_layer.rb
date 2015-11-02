class PolishLayer < ActiveRecord::Base  
  default_scope { order(ordering: :DESC) }
  scope :bottom_up, -> { unscope(:order).order(ordering: :ASC) }

  belongs_to :polish, counter_cache: :layers_count

end