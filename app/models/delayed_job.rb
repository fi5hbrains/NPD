module Delayed
  class Job < ActiveRecord::Base
    self.table_name = "delayed_jobs"
    attr_accessible :layer_ordering
  end
end