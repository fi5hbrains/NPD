class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: :votes_count
end