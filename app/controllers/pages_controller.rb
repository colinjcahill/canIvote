class PagesController < ApplicationController
  def index
    @states = YAML.load_file('./app/models/states.yml')
    # @poll = Poll.new
    binding.pry
  end
end
