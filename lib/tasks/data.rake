namespace :data do
  desc "Updates all entries in the state db with fresh data"
  task refresh: :environment do
    State.poll_for_data
    State.all.each {|s| puts "Refreshing state " + s.state_long; s.refresh}
  end
end
