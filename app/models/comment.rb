class Comment < ActiveRecord::Base
  after_save :counter_up
  before_destroy :counter_down
  scope :older_first, -> { unscope(:order).order(created_at: :ASC) }
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many   :comments, as: :commentable, dependent: :destroy
  
  private

  def counter_up
    parent = find_root(self.commentable)
    parent.comments_count += 1 if parent.comments_count
    parent.save
  end
  def counter_down
    parent = find_root(self.commentable)
    parent.comments_count -= 1 if parent.comments_count
    parent.save
  end
  
  def find_root parent
    parent.class.name == 'Comment' ? find_root( parent.commentable) : parent
  end
end