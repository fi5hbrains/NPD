class Synonym < ActiveRecord::Base
  belongs_to :word, polymorphic: true
  default_scope {order 'created_at ASC'}
end