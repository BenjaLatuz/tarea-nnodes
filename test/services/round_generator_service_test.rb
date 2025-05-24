require 'test_helper'

class RoundGeneratorServiceTest < ActiveSupport::TestCase
  setup do
    @player1 = players(:one)
    @player2 = players(:two)
    @player1.update!(money: 10000)
    @player2.update!(money: 5000)
  end

  test "genera una ronda con apuestas para jugadores activos" do
    assert_difference 'Round.count', 1 do
      assert_difference 'Bet.count', 2 do  # 2 jugadores activos
        round = RoundGeneratorService.generate_round!
        
        # Verificar que la ronda se creó correctamente
        assert round.result.in?(Round::COLORS), "Debe tener un resultado válido"
        assert_not_nil round.played_at, "Debe tener fecha/hora"
        assert_not_nil round.max_temperature, "Debe tener temperatura"
        
        # Verificar que se crearon las apuestas
        assert_equal 2, round.bets.count, "Debe tener 2 apuestas"
        
        # Verificar que cada apuesta es válida
        round.bets.each do |bet|
          assert bet.color.in?(Round::COLORS), "Debe tener un color válido"
          assert bet.amount > 0, "Debe tener un monto positivo"
          assert_not_nil bet.profit, "Debe tener profit calculado"
        end
        
        # Verificar que se actualizó el dinero de los jugadores
        @player1.reload
        @player2.reload
        assert @player1.money != 10000, "El dinero del jugador 1 debe cambiar"
        assert @player2.money != 5000, "El dinero del jugador 2 debe cambiar"
      end
    end
  end

  test "no genera apuestas para jugadores sin dinero" do
    @player1.update!(money: 0)
    
    assert_difference 'Round.count', 1 do
      assert_difference 'Bet.count', 1 do  # Solo 1 jugador activo
        round = RoundGeneratorService.generate_round!
        assert_equal 1, round.bets.count, "Debe tener solo 1 apuesta"
        assert_equal @player2.id, round.bets.first.player_id, "Debe ser del jugador con dinero"
      end
    end
  end
end 