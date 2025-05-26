class GenerateRoundJob
  include Sidekiq::Job

  def perform
    Rails.logger.info "Iniciando generación automática de ronda"
    RoundGeneratorService.generate_round!
    Rails.logger.info "Ronda generada exitosamente"
  rescue StandardError => e
    Rails.logger.error "Error al generar ronda automática: #{e.message}"
    raise e
  end
end 