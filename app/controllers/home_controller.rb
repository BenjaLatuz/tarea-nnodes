class HomeController < ApplicationController
  def index
    @rounds = Round.includes(:bets => :player).order(played_at: :desc)
  end
end 