class PagesController < ApplicationController
  include Pollster
  include Charts
  def index
    @charts = Chart.where(:topic => "2016-president")
    @states = YAML.load_file('./lib/states.yml')
    @states.each do |state, hash|
      logger.info "Iterating through states..."
      poll = Charts::Poll.new
      poll.retrieve_poll @states[state]["short_name"], @charts
      hash["poll"] = poll
    end
    logger.info "Iterating completed"
  end
end
