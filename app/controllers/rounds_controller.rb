class RoundsController < ApplicationController
  def create
    @round = RoundGeneratorService.generate_round!
    redirect_to root_path, notice: "Nueva ronda generada exitosamente"
  rescue StandardError => e
    redirect_to root_path, alert: "Error al generar la ronda: #{e.message}"
  end
end 