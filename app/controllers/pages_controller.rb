class PagesController < ApplicationController
  include Charts
  def index
    @states = YAML.load_file('./lib/states.yml')
    @states.keys.each do |state|
      poll = Poll.new
      poll.search_and_parse state
      @states << poll
    end
    binding.pry
  end
end
