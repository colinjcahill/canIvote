class AddCautionToState < ActiveRecord::Migration
  def change
    add_column :states, :caution, :boolean
  end
end
