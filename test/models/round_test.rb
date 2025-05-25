require "test_helper"

class RoundTest < ActiveSupport::TestCase
  setup do
    @round = Round.new
  end

  test "debe asignar un resultado válido antes de validar" do
    mock_weather_service do
      @round.valid?  # Trigger callbacks
      assert_includes Round::COLORS, @round.result
    end
  end

  test "debe asignar played_at antes de validar" do
    mock_weather_service do
      @round.valid?  # Trigger callbacks
      assert_not_nil @round.played_at
      assert_instance_of ActiveSupport::TimeWithZone, @round.played_at
    end
  end

  test "debe asignar max_temperature antes de validar" do
    mock_weather_service do
      @round.valid?  # Trigger callbacks
      assert_not_nil @round.max_temperature
      assert_kind_of Numeric, @round.max_temperature
      assert_equal 20.5, @round.max_temperature
    end
  end

  test "no debe permitir un resultado inválido" do
    @round = Round.new
    def @round.set_result; end  # Anular el callback
    mock_weather_service do
      @round.result = "azul"
      assert_not @round.valid?
      assert_includes @round.errors[:result], "is not included in the list"
    end
  end

  test "debe requerir played_at" do
    @round = Round.new
    def @round.set_played_at; end  # Anular el callback
    mock_weather_service do
      assert_not @round.valid?
      assert_includes @round.errors[:played_at], "can't be blank"
    end
  end

  test "debe requerir max_temperature" do
    @round = Round.new
    def @round.set_max_temperature; end  # Anular el callback
    mock_weather_service do
      assert_not @round.valid?
      assert_includes @round.errors[:max_temperature], "can't be blank"
    end
  end

  test "debe poder tener múltiples apuestas" do
    mock_weather_service do
      round = rounds(:one)
      bet1 = Bet.create!(round: round, player: players(:one), amount: 100, color: "rojo")
      bet2 = Bet.create!(round: round, player: players(:two), amount: 200, color: "negro")
      
      assert_includes round.bets, bet1
      assert_includes round.bets, bet2
    end
  end

  test "debe eliminar apuestas asociadas al eliminar la ronda" do
    mock_weather_service do
      round = rounds(:one)
      initial_bets = round.bets.count
      new_bet = Bet.create!(round: round, player: players(:one), amount: 100, color: "rojo")
      
      assert_difference('Bet.count', -(initial_bets + 1)) do
        round.destroy
      end
    end
  end

  test "la distribución de resultados debe ser aproximadamente correcta" do
    mock_weather_service do
      resultados = 1000.times.map { Round.new.tap(&:valid?).result }
      
      verdes = resultados.count("verde")
      rojos = resultados.count("rojo")
      negros = resultados.count("negro")
      
      # Verde debe ser aproximadamente 2%
      assert_in_delta 0.02, verdes.to_f / 1000, 0.02
      
      # Rojo y negro deben ser aproximadamente 49% cada uno
      assert_in_delta 0.49, rojos.to_f / 1000, 0.05
      assert_in_delta 0.49, negros.to_f / 1000, 0.05
    end
  end
end
