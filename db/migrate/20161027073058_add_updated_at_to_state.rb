class AddUpdatedAtToState < ActiveRecord::Migration
  def change
    add_column :states, :updated_538, :datetime
    add_column :states, :pollster_updated, :datetime
  end
end
