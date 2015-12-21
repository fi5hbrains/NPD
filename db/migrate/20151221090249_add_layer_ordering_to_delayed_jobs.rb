class AddLayerOrderingToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :layer_ordering, :integer
  end
end
