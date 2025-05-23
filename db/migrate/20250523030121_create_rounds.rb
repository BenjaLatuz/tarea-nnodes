class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.string :result
      t.datetime :played_at

      t.timestamps
    end
  end
end
