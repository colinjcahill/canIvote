class State < ActiveRecord::Base
  include Pollster
  require 'nokogiri'
  require 'open-uri'
  require 'yaml'
  require 'pollster'

  @@pull_time = Time.now
  @@five_thirty_eight = Nokogiri::HTML(open("http://projects.fivethirtyeight.com/2016-election-forecast"))
  @@huff = Pollster::Chart.where(:topic => "2016-president")

  def fte_pull_and_parse(state_shortcode)
    clinton_chance = @@five_thirty_eight.search("div[data-set=#{state_shortcode.upcase}] div.candidate.dem p[data-key=winprob]").text.tr('%<>','')
    trump_chance = @@five_thirty_eight.search("div[data-set=#{state_shortcode.upcase}] div.candidate.rep p[data-key=winprob]").text.tr('%<>','')
    @scraped_hash = {
      :state => state_shortcode.upcase,
      :updated => @@pull_time,
      :clinton => clinton_chance,
      :trump => trump_chance
    }
  end

  def huff_pull_and_parse(state_shortcode)
    poll = @@huff.find {|chart| chart.state == state_shortcode.upcase}
    poll.estimates_by_date.first.to_json if poll
  end

  def refresh
    fte_data = fte_pull_and_parse(self.state_short)
    huff_data = huff_pull_and_parse(self.state_short)
    huff_data ? (self.pollster_dump = huff_data; self.pollster = true; self.pollster_updated = JSON.parse(huff_data)["date"].to_datetime) : (puts "No Pollster Data")
    fte_data ? (self.updated_538 = fte_data[:updated]; self.percent_clinton = fte_data[:clinton]; self.percent_trump = fte_data[:trump]) : "No FiveThirtyEight Data"
    self.save
  end
end
