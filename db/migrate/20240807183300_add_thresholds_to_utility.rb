class AddThresholdsToUtility < ActiveRecord::Migration[6.1]
  def change
    add_column :utilities, :content_length_thresholds, :jsonb, default: {}
  end
end
