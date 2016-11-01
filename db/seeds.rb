# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
@states = YAML.load_file('./lib/states.yml')
@states.each do |long, short|
  state = State.new
  puts "Creating seed data for " + long
  state.state_long = long
  state.state_short = short
  state.jill_on_ballot = true
  state.refresh
end
