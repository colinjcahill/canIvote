class PagesController < ApplicationController
  include Charts
  def index
    @states = YAML.load_file('./lib/states.yml')
    binding.pry
  end
end
