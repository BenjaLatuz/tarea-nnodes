class Bet < ApplicationRecord
  belongs_to :player
  belongs_to :round

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :color, presence: true, inclusion: { in: Round::COLORS }
  validates :profit, numericality: true, allow_nil: true

  before_validation :set_random_color

  private

  def set_random_color
    random = rand(100)
    self.color = if random < 2
                   'verde'
                 elsif random < 51
                   'rojo'
                 else
                   'negro'
                 end
  end
end
