class Bet < ApplicationRecord
  require_dependency 'bet_calculator_service'

  belongs_to :player
  belongs_to :round

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :color, presence: true, inclusion: { in: Round::COLORS }
  validates :profit, numericality: true, allow_nil: true

  before_validation :set_random_color, on: :create

  private

  def set_random_color
    return if color.present?  # No cambiar si ya tiene color
    
    random = rand(100)
    self.color = if random < 2
                   "verde"
    elsif random < 51
                   "rojo"
    else
                   "negro"
    end
    Rails.logger.info "Apuesta #{id || 'nueva'}: Color establecido como #{color}"
  end
end