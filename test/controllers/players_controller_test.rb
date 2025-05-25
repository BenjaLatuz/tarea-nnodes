require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:one)
    @valid_params = { player: { name: "Nuevo Jugador", money: 15000 } }
  end

  test "debe obtener index" do
    get players_path
    assert_response :success
  end

  test "debe obtener new" do
    get new_player_path
    assert_response :success
  end

  test "debe crear jugador" do
    assert_difference("Player.count") do
      post players_path, params: @valid_params
    end

    assert_redirected_to player_path(Player.last)
    assert_equal "Jugador creado exitosamente", flash[:notice]
  end

  test "no debe crear jugador con parámetros inválidos" do
    assert_no_difference("Player.count") do
      post players_path, params: { player: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "debe obtener show" do
    get player_path(@player)
    assert_response :success
  end

  test "debe obtener edit" do
    get edit_player_path(@player)
    assert_response :success
  end

  test "debe actualizar jugador" do
    patch player_path(@player), params: { player: { name: "Nombre Actualizado" } }
    assert_redirected_to player_path(@player)
    assert_equal "Jugador actualizado exitosamente", flash[:notice]
    
    @player.reload
    assert_equal "Nombre Actualizado", @player.name
  end

  test "no debe actualizar jugador con parámetros inválidos" do
    patch player_path(@player), params: { player: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "debe eliminar jugador" do
    assert_difference("Player.count", -1) do
      delete player_path(@player)
    end

    assert_redirected_to players_path
    assert_equal "Jugador eliminado exitosamente", flash[:notice]
  end

  test "debe responder con JSON cuando se solicita" do
    get player_path(@player, format: :json)
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @player.name, json_response["name"]
  end
end
