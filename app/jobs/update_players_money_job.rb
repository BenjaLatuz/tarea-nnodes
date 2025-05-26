class UpdatePlayersMoneyJob
  include Sidekiq::Job

  def perform
    Rails.logger.info "Iniciando actualización de dinero para todos los jugadores"
    PlayerMoneyService.update_all_players_money!
    Rails.logger.info "Dinero actualizado exitosamente para todos los jugadores"
  rescue StandardError => e
    Rails.logger.error "Error al actualizar dinero de jugadores: #{e.message}"
    raise e
  end
end 