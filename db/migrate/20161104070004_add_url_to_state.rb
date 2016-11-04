class AddUrlToState < ActiveRecord::Migration
  def change
    add_column :states, :fivethirtyeight_url, :string
  end
end
