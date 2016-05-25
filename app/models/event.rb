class Event < ActiveRecord::Base
  after_create  :update_counter
  belongs_to :user
  
  private
  
  def update_counter
    u = self.user
    u.events_count += 1
    u.save
  end
end
