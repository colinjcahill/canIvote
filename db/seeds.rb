# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
@states = YAML.load_file('./lib/states.yml')
State.poll_for_data
@states.each do |long, short|
  state = State.new
  puts "Creating seed data for " + long
  state.state_long = long
  state.state_short = short
  state.fivethirtyeight_url = "http://projects.fivethirtyeight.com/2016-election-forecast" + "/"+ state.state_long.parameterize
  state.refresh
end

State.all.update_all(jill_on_ballot: true, splits_vote: false)
State.where(state_short: ["SD", "NV", "OK", "IN", "NC", "GA"]).update_all(jill_on_ballot: false)
State.where(state_short: ["IN", "NC", "GA"]).update_all(jill_write_in: true)
State.where(state_short: ["SD", "OK", "NV"]).update_all(can_I_vote: false)
State.where(state_short: ["NE", "ME"]).update_all(splits_vote: true)
