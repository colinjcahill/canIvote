class AddNameToState < ActiveRecord::Migration
  def change
    add_column :states, :state_long, :string
    add_column :states, :state_short, :string
  end
end
