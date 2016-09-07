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

    def retrieve_poll(state_shortname, charts)
      index = charts.map {|p| p.state}.index state_shortname
      if index
        result = charts[index].estimates_by_date.first
        if result
          @date = result[:date]
          parsed = result[:estimates].map {|i| Hash[*i.invert.keys]}.flatten.inject(:merge)
          @trump_poll = parsed["Trump"]
          @clinton_poll = parsed["Clinton"]
          @other_poll = parsed["Other"]
          @undecided_poll = parsed["Undecided"]
          @no_data = false
        else
          @no_data = true
        end
      else
        @no_data = true
      end
    end
  end
end
