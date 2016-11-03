class PagesController < ApplicationController
  def index
    @states = State.all
    @yes_jill = "Yes!  You can vote for Jill Stein this election!"
    @no_jill = "There are one or more reasons that you cannot or should not vote for Jill Stein this election:"
  end
end
