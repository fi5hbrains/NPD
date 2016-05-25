class Comment < ActiveRecord::Base
  after_save :counter_up
  before_destroy :counter_down
  scope :older_first, -> { unscope(:order).order(created_at: :ASC) }
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many   :comments, as: :commentable, dependent: :destroy
  
  private

  def counter_up
    parent = find_root(mother = self.commentable)
    parent.comments_count += 1 if parent.comments_count
    parent.save
    if mother.user_id == parent.user_id && self.user_id != parent.user_id
      Event.new(event_type: 'polish_comment_and_reply', user_id: parent.user_id, author: self.user_name).save 
    else
      Event.new(event_type: 'reply', user_id: mother.user_id, author: self.user_name).save if mother.class.name == 'Comment' && self.user_id != mother.user_id
      Event.new(event_type: 'polish_comment', user_id: parent.user_id, author: self.user_name).save if self.user_id != parent.user_id
    end
  end
  def counter_down
    parent = find_root(self.commentable)
    parent.comments_count -= 1 if parent.comments_count
    parent.save
    Event.where(eventable_id: self.id, eventable_type: 'Comment').each(&:destroy)
  end
  
  def find_root parent
    parent.class.name == 'Comment' ? find_root( parent.commentable) : parent
  end
end