class CreateBets < ActiveRecord::Migration[8.0]
  def change
    create_table :bets do |t|
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.decimal :amount
      t.string :color
      t.decimal :profit

      t.timestamps
    end
  end
end
