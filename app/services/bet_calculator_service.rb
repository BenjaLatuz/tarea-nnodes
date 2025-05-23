# encoding: utf-8

class BetCalculatorService
  require_relative 'weather_service'

  def self.calculate_percentage(temperature)
    if temperature > 23
      rand(3..7)  # 3-7% si la temperatura es mayor a 23°C
    else
      rand(5..12) # 5-12% en caso contrario
    end
  end

  def self.calculate_percentage_with_weather
    max_temp = WeatherService.get_max_temperature
    calculate_percentage(max_temp)
  end
end 