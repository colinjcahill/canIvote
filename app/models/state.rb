class State < ActiveRecord::Base
  include Pollster
  require 'nokogiri'
  require 'open-uri'
  require 'yaml'
  require 'pollster'

  attr_accessor :winning_margin, :negative_advice, :pollster_parsed

  def self.poll_for_data
    @@pull_time = Time.now
    @@five_thirty_eight = Nokogiri::HTML(open("http://projects.fivethirtyeight.com/2016-election-forecast"))
    @@huff = Pollster::Chart.where(:topic => "2016-president")
  end


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
    poll.estimates_by_date.first.to_json if (poll && poll.estimates_by_date.any?)
  end

  def winning_margin
    (self.percent_clinton - self.percent_trump).abs
  end

  def negative_advice
    reasons = [self.jill_on_ballot, self.calculate]
    responses = ["Unfortunately, Jill Stein is not on the ballot in this state.", "The margin of victory between the Republican and Democratic candidate is this state is " + reasons.last + "."]
    reasons.first ? responses.shift : responses
    return responses
  end

  def caution_advice
    responses = []
    if self.jill_write_in
      responses << "Jill Stein is not explicitly present on the ballot in this state.  In order to vote for her you will need to write her name in as a separate candidate."
    elsif self.caution
      responses << "While FiveThirtyEight predicts a moderate chance of victory for Clinton, you should make sure you are well-informed of the risks before voting in this state."
    end
    return responses
  end

  def pollster_parsed
    results = (JSON.parse self.pollster_dump)["estimates"]
  end

  def calculate
    small_win = 0..29.9999999
    moderate_win = 30..49.9999999
    large_win = 50..100

    case self.winning_margin
    when small_win
      self.can_I_vote = false
      self.save
      "small"
    when moderate_win
      self.caution = true
      self.can_I_vote = true
      self.save
      "moderate"
    when large_win
      self.caution = false
      self.can_I_vote = true
      self.save
      "large"
    end
  end

  def refresh
    fte_data = fte_pull_and_parse(self.state_short)
    huff_data = huff_pull_and_parse(self.state_short)
    huff_data ? (self.pollster_dump = huff_data; self.pollster = true; self.pollster_updated = JSON.parse(huff_data)["date"].to_datetime) : (puts "No Pollster Data for " + self.state_long)
    fte_data ? (self.updated_538 = fte_data[:updated]; self.percent_clinton = fte_data[:clinton]; self.percent_trump = fte_data[:trump]) : "No FiveThirtyEight Data"
    self.calculate
  end
end
