require "test_helper"

class BetTest < ActiveSupport::TestCase
  setup do
    @player = players(:one)
    @round = rounds(:one)
    @bet = Bet.new(
      player: @player,
      round: @round,
      amount: 1000
    )
  end

  test "debe ser válida con atributos correctos" do
    assert @bet.valid?
  end

  test "debe requerir un monto positivo" do
    @bet.amount = 0
    assert_not @bet.valid?
    assert_includes @bet.errors[:amount], "must be greater than 0"

    @bet.amount = -100
    assert_not @bet.valid?
    assert_includes @bet.errors[:amount], "must be greater than 0"
  end

  test "debe requerir un color válido" do
    @bet.color = "azul"
    assert_not @bet.valid?
    assert_includes @bet.errors[:color], "is not included in the list"
  end

  test "debe permitir profit nulo" do
    @bet.profit = nil
    assert @bet.valid?
  end

  test "debe requerir que profit sea numérico si está presente" do
    @bet.profit = "no numérico"
    assert_not @bet.valid?
    assert_includes @bet.errors[:profit], "is not a number"
  end

  test "debe asignar un color aleatorio antes de validar si no tiene uno" do
    @bet.valid?  # Trigger callbacks
    assert_includes Round::COLORS, @bet.color
  end

  test "no debe cambiar el color si ya tiene uno asignado" do
    @bet.color = "verde"
    @bet.valid?  # Trigger callbacks
    assert_equal "verde", @bet.color
  end

  test "debe pertenecer a un jugador" do
    @bet.player = nil
    assert_not @bet.valid?
    assert_includes @bet.errors[:player], "must exist"
  end

  test "debe pertenecer a una ronda" do
    @bet.round = nil
    assert_not @bet.valid?
    assert_includes @bet.errors[:round], "must exist"
  end

  test "la distribución de colores debe ser aproximadamente correcta" do
    colores = 1000.times.map { Bet.new(player: @player, round: @round, amount: 100).tap(&:valid?).color }
    
    verdes = colores.count("verde")
    rojos = colores.count("rojo")
    negros = colores.count("negro")
    
    # Verde debe ser aproximadamente 2%
    assert_in_delta 0.02, verdes.to_f / 1000, 0.02
    
    # Rojo y negro deben ser aproximadamente 49% cada uno
    assert_in_delta 0.49, rojos.to_f / 1000, 0.05
    assert_in_delta 0.49, negros.to_f / 1000, 0.05
  end
end
