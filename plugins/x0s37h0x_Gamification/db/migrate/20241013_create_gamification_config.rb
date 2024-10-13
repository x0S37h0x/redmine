# plugins/x0s37h0x_Gamification/db/migrate/01_create_gamification_config.rb
class CreateGamificationConfig < ActiveRecord::Migration[7.2]
  def change
    create_table :gamification_configs do |t|
      t.integer :exp_leicht, default: 10
      t.integer :exp_mittel, default: 20
      t.integer :exp_schwer, default: 30

      t.timestamps
    end
  end
end
