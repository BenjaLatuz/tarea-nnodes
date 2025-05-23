class Round < ApplicationRecord
  COLORS = %w[verde rojo negro].freeze

  validates :result, presence: true, inclusion: { in: COLORS }
  validates :played_at, presence: true

  before_validation :set_played_at, on: :create

  private

  def set_played_at
    self.played_at ||= Time.current
  end
end
