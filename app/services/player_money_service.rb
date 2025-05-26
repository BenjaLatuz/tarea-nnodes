class PlayerMoneyService
  def self.update_all_players_money!
    Player.transaction do
      Player.find_each do |player|
        player.update!(money: player.money + 10000)
      end
    end
  end
end 