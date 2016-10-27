class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.float :percent_clinton
      t.float :percent_trump
      t.boolean :pollster
      t.boolean :jill_on_ballot
      t.boolean :jill_write_in
      t.string :pollster_dump
      t.boolean :splits_vote
      t.boolean :can_I_vote

      t.timestamps null: false
    end
  end
end
