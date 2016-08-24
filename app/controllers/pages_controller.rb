class PagesController < ApplicationController
  def index
    @states = YAML.load_file('./app/models/states.yml')
  end
end
