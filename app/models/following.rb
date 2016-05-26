class Following < ActiveRecord::Base
  after_create :create_event
  belongs_to :followee, class_name: 'User', foreign_key: 'followee_id', counter_cache: :follower_count 
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id', counter_cache: :followee_count
  
  private
  
  def create_event
    Event.new(event_type: 'following', user_id: self.followee_id, author: User.find(self.follower_id).name, eventable_type: 'User', eventable_id: self.follower_id).save
  end
end