class Comment < ActiveRecord::Base
  include Slugify

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
      Event.new(event_type: 'polish_comment_and_reply', user_id: parent.user_id, author: self.user_name, eventable_type: parent.class.name, eventable_id: parent.id, body: self.body).save 
    else
      Event.new(event_type: 'reply', user_id: mother.user_id, author: self.user_name, eventable_type: parent.class.name, eventable_id: parent.id, body: self.body).save if mother.class.name == 'Comment' && self.user_id != mother.user_id
      Event.new(event_type: 'polish_comment', user_id: parent.user_id, author: self.user_name, eventable_type: parent.class.name, eventable_id: parent.id, body: self.body).save if self.user_id != parent.user_id
    end
    if self.body.match '@'
      parse_usernames.each do |u|
        u_id = User.find_by_slug(slugify(u)).id
        unless u_id == self.user_id && self.user_id != mother.user_id && self.user_id != parent.user_id
          Event.new(event_type: 'mention', user_id: u_id, author: self.user_name, eventable_type: parent.class.name, eventable_id: parent.id, body: self.body).save
        end
      end
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
  
  def parse_usernames
    self.body.scan(/(?<=@)[^\s|,\s|.\s|,@]+/).uniq
  end
end