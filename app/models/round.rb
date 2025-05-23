class Round < ApplicationRecord
  require_dependency 'weather_service'

  has_many :bets, dependent: :destroy

  COLORS = %w[verde rojo negro].freeze

  validates :result, presence: true, inclusion: { in: COLORS }
  validates :played_at, presence: true
  validates :max_temperature, presence: true, numericality: true

  before_validation :set_result
  before_validation :set_played_at, on: :create
  before_validation :set_max_temperature, on: :create

  private

  def set_result
    random = rand(100)
    self.result = if random < 2
                    "verde"
    elsif random < 51
                    "rojo"
    else
                    "negro"
    end
  end

  def set_played_at
    self.played_at ||= Time.current
  end

  def set_max_temperature
    self.max_temperature = WeatherService.get_max_temperature
  end
end
