# encoding: utf-8

class BetCalculatorService
  def self.calculate_percentage(temperature)
    if temperature > 23
      rand(3..7)  # 3-7% si la temperatura es mayor a 23°C
    else
      rand(5..12) # 5-12% en caso contrario
    end
  end

  def self.calculate_bet_amount(player, temperature)
    return player.money.to_i if player.money <= 5000

    percentage = calculate_percentage(temperature)
    (player.money * percentage / 100.0).round.to_i
  end

  def self.calculate_profit(bet, round_result)
    return 0 unless bet && round_result

    profit = if bet.color == round_result
              if round_result == "verde"
                bet.amount * 15  # x15 para verde
              else
                bet.amount * 2   # x2 para rojo o negro
              end
            else
              -bet.amount       # Pérdida total si no acierta
            end

    Rails.logger.info "Calculando profit para apuesta #{bet.id}: monto=#{bet.amount}, color_apostado=#{bet.color}, resultado=#{round_result}, profit=#{profit}"
    profit
  end

  def self.update_player_money!(bet, round_result)
    Rails.logger.info "Actualizando dinero para jugador #{bet.player.name} (apuesta #{bet.id})"
    Rails.logger.info "Estado inicial: dinero=#{bet.player.money}, monto_apostado=#{bet.amount}"
    
    profit = calculate_profit(bet, round_result)
    
    bet.update!(profit: profit)
    bet.player.update!(money: bet.player.money + profit)
    
    Rails.logger.info "Estado final: profit=#{profit}, nuevo_dinero=#{bet.player.money}"
  end
end 