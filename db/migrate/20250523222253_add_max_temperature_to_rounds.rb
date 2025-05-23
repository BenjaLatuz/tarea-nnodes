class AddMaxTemperatureToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :max_temperature, :float
  end
end
