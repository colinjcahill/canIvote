module Charts
  class Poll
    include Pollster
    require 'yaml'
    require 'pollster'

    attr_accessor :date, :vote_for_jill_bool, :clinton_poll, :trump_poll, :other_poll, :undecided_poll, :no_data

    def initialize
      @date = nil
      @vote_for_jill_bool = nil
      @clinton_poll = nil
      @trump_poll = nil
      @other_poll = nil
      @undecided_poll = nil
      @no_data = nil
    end

    def poll_by_state(state)
      states = YAML.load_file('./lib/states.yml')
      chart = Chart.where(:topic => "2016-president", :state =>"#{states[state]}").first
      chart ? chart.estimates_by_date.first : nil
    end

    def search_and_parse(state_fullname)
      result = poll_by_state(state_fullname)
      if result
        @date = result[:date]
        parsed = result[:estimates].map {|i| Hash[*i.invert.keys]}.flatten.inject(:merge)
        @trump_poll = parsed["Trump"]
        @clinton_poll = parsed["Clinton"]
        @other_poll = parsed["Other"]
        @undecided_poll = parsed["Undecided"]
      else
        @no_data = true
      end
    end
  end
end
