class PagesController < ApplicationController
  include Charts
  def index
    @states = YAML.load_file('./lib/states.yml')
    @charts = Chart.where(:topic => "2016-president")

    @states.each do |state, hash|
      logger.info "Iterating through states..."
      poll = Poll.new
      poll.retrieve_poll state, @charts
      hash["poll"] = poll
    end
    logger.info "Iterating completed"
  end
end
