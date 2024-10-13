# plugins/x0s37h0x_Gamification/app/models/gamification_config.rb
class GamificationConfig < ActiveRecord::Base
  # Definiere die Standardwerte
  after_initialize do
    self.exp_leicht ||= 10
    self.exp_mittel ||= 20
    self.exp_schwer ||= 30
  end
end
