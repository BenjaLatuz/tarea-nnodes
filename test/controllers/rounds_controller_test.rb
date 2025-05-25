require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "debe crear una nueva ronda" do
    mock_weather_service do
      assert_difference('Round.count') do
        post rounds_path
      end

      assert_redirected_to root_path
      assert_equal "Nueva ronda generada exitosamente", flash[:notice]
    end
  end

  test "debe manejar errores al crear una ronda" do
    # Simulamos un error en el servicio
    RoundGeneratorService.stub :generate_round!, -> { raise StandardError.new("Error de prueba") } do
      post rounds_path
      
      assert_redirected_to root_path
      assert_equal "Error al generar la ronda: Error de prueba", flash[:alert]
    end
  end
end 