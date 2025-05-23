# encoding: utf-8

class WeatherService
  require 'net/http'
  require 'json'

  def self.get_max_temperature
    api_key = ENV['OPENWEATHER_API_KEY']
    city = 'Santiago,CL'
    url = "http://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_key}&units=metric"
    
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      
      # Obtenemos y mostramos todas las temperaturas para información
      temps = data['list'].map do |forecast|
        {
          temp: forecast['main']['temp'].round(1),
          time: Time.at(forecast['dt']).strftime('%Y-%m-%d %H:%M')
        }
      end

      puts "\nTemperaturas pronosticadas:"
      temps.each { |t| puts "#{t[:time]}: #{t[:temp]}°C" }
      
      temps.map { |t| t[:temp] }.max
    else
      raise "Error al obtener el pronóstico: #{response.code} #{response.message}"
    end
  end
end
