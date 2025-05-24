require 'test_helper'

class BetCalculatorServiceTest < ActiveSupport::TestCase
  setup do
    @player = players(:one)  # Asumiendo que tenemos un fixture
    @temperature = 20  # Temperatura base para pruebas
  end

  test "calcula porcentaje correcto según temperatura" do
    # Temperatura alta (>23)
    porcentaje_alto = BetCalculatorService.calculate_percentage(24)
    assert porcentaje_alto.between?(3, 7), "Con temperatura alta debe estar entre 3-7%"

    # Temperatura baja (≤23)
    porcentaje_bajo = BetCalculatorService.calculate_percentage(20)
    assert porcentaje_bajo.between?(5, 12), "Con temperatura baja debe estar entre 5-12%"
  end

  test "calcula monto correcto según dinero del jugador" do
    # Jugador con poco dinero (≤5000)
    @player.update!(money: 3000)
    monto = BetCalculatorService.calculate_bet_amount(@player, @temperature)
    assert_equal 3000, monto, "Debe apostar todo si tiene ≤5000"

    # Jugador con más dinero (>5000)
    @player.update!(money: 10000)
    monto = BetCalculatorService.calculate_bet_amount(@player, @temperature)
    assert monto.between?(500, 1200), "Debe apostar entre 5-12% con temp ≤23"
  end

  test "calcula profit correctamente según resultado" do
    bet = Bet.new(amount: 1000)

    # Ganar con verde (x15)
    bet.color = "verde"
    profit = BetCalculatorService.calculate_profit(bet, "verde")
    assert_equal 15000, profit, "Debe ganar 15x al acertar verde"

    # Ganar con rojo (x2)
    bet.color = "rojo"
    profit = BetCalculatorService.calculate_profit(bet, "rojo")
    assert_equal 2000, profit, "Debe ganar 2x al acertar rojo"

    # Ganar con negro (x2)
    bet.color = "negro"
    profit = BetCalculatorService.calculate_profit(bet, "negro")
    assert_equal 2000, profit, "Debe ganar 2x al acertar negro"

    # Perder
    bet.color = "rojo"
    profit = BetCalculatorService.calculate_profit(bet, "negro")
    assert_equal -1000, profit, "Debe perder todo al no acertar"
  end
end 