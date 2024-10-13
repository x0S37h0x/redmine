class SetDefaultGamificationSettings < ActiveRecord::Migration[7.2]
  def up
    # Check if the setting already exists, and only set it if it doesn't
    unless Setting.plugin_x0s37h0x_Gamification.present?
      Setting.plugin_x0s37h0x_Gamification = {
        'exp_values' => {
          'leicht' => 10,
          'mittel' => 20,
          'schwer' => 30
        }
      }
    end

    # Konvertiere die Einstellungen in JSON
    setting = Setting.find_by(name: 'plugin_x0s37h0x_Gamification')
    if setting
      setting.update_column(:value, setting.value.to_json)
    end
  end

  def down
    # Optionally, reset to defaults or do nothing on rollback
    Setting.plugin_x0s37h0x_Gamification = {} if Setting.plugin_x0s37h0x_Gamification.present?
  end
end