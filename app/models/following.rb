class Following < ActiveRecord::Base
  belongs_to :followee, class_name: 'User', foreign_key: 'followee_id', counter_cache: :follower_count 
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id', counter_cache: :followee_count
end