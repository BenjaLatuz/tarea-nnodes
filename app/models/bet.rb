class Bet < ApplicationRecord
  require_dependency 'bet_calculator_service'

  belongs_to :player
  belongs_to :round

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :color, presence: true, inclusion: { in: Round::COLORS }
  validates :profit, numericality: true, allow_nil: true

  before_validation :set_random_color
  before_validation :calculate_amount, on: :create

  private

  def calculate_amount
    return self.amount = player.money.to_i if player.money <= 5000

    percentage = BetCalculatorService.calculate_percentage_with_weather
    self.amount = (player.money * percentage / 100.0).round.to_i
  end

  def set_random_color
    random = rand(100)
    self.color = if random < 2
                   "verde"
    elsif random < 51
                   "rojo"
    else
                   "negro"
    end
  end
end