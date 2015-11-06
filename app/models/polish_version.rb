class PolishVersion < ActiveRecord::Base
  default_scope {order('created_at DESC')}

  belongs_to :master, class_name: 'Polish', foreign_key: 'polish_id'
  serialize :polish, Hash
  
end