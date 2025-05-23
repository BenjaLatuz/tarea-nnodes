class Player < ApplicationRecord
  validates :name, presence: true
  validates :money, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :set_default_money

  private

  def set_default_money
    self.money ||= 10000
  end
end
