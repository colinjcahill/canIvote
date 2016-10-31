class PagesController < ApplicationController
  def index
    @states = State.all
  end
end
