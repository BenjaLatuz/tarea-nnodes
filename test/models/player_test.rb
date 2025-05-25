require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = Player.new(name: "Test Player")
  end

  test "debe ser válido con atributos correctos" do
    assert @player.valid?
  end

  test "debe requerir un nombre" do
    @player.name = nil
    assert_not @player.valid?
    assert_includes @player.errors[:name], "can't be blank"
  end

  test "debe tener dinero mayor o igual a 0" do
    @player.money = -100
    assert_not @player.valid?
    assert_includes @player.errors[:money], "must be greater than or equal to 0"
  end

  test "debe tener 10000 como dinero por defecto" do
    player = Player.new(name: "Nuevo Jugador")
    player.valid?  # Trigger callbacks
    assert_equal 10000, player.money
  end

  test "debe poder tener múltiples apuestas" do
    player = players(:one)
    bet1 = Bet.create!(player: player, round: rounds(:one), amount: 100, color: "rojo")
    bet2 = Bet.create!(player: player, round: rounds(:one), amount: 200, color: "negro")
    
    assert_includes player.bets, bet1
    assert_includes player.bets, bet2
  end

  test "debe eliminar apuestas asociadas al eliminar el jugador" do
    player = players(:one)
    initial_bets = player.bets.count
    new_bet = Bet.create!(player: player, round: rounds(:one), amount: 100, color: "rojo")
    
    assert_difference('Bet.count', -(initial_bets + 1)) do
      player.destroy
    end
  end
end
