class RoundGeneratorService
  def self.generate_round!
    ActiveRecord::Base.transaction do
      # Crear la ronda con su resultado
      round = Round.new
      round.save!
      Rails.logger.info "Round #{round.id} creada con resultado #{round.result}"

      # Obtener todos los jugadores activos (con dinero > 0)
      active_players = Player.where("money > 0")
      Rails.logger.info "Encontrados #{active_players.count} jugadores activos"

      # Crear apuestas para jugadores activos
      active_players.each do |player|
        bet = round.bets.create!(
          player: player,
          color: generate_random_color,
          amount: BetCalculatorService.calculate_bet_amount(player, round.max_temperature)
        )
        
        # Calcular y actualizar el profit inmediatamente
        profit = BetCalculatorService.calculate_profit(bet, round.result)
        bet.update!(profit: profit)
        player.update!(money: player.money + profit)
        
        Rails.logger.info "Apuesta #{bet.id}: jugador=#{player.name}, color=#{bet.color}, monto=#{bet.amount}, profit=#{profit}"
      end

      Rails.logger.info "Round #{round.id} finalizada con #{round.bets.count} apuestas"
      round
    end
  end

  private

  def self.generate_random_color
    random = rand(100)
    if random < 2
      "verde"
    elsif random < 51
      "rojo"
    else
      "negro"
    end
  end
end 