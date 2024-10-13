# plugins/x0s37h0x_Gamification/lib/issue_patch.rb
module IssuePatch
  extend ActiveSupport::Concern

  included do
    after_save :increase_user_exp, if: :closed_with_custom_tracker?
  end

  private

  def closed_with_custom_tracker?
    status.is_closed? && tracker.name == 'Tägliche Aufgabe'
  end

  def increase_user_exp
  # Hole die Komplexität und entsprechende EXP-Werte aus den Einstellungen
  complexity = custom_field_value(CustomField.find_by_name('Komplexität'))
  
  # Lade exp_values-Einstellungen aus der Datenbank und setze Standardwerte, falls nil
  exp_values = Setting.plugin_x0s37h0x_Gamification.dig('exp_values') || { 'leicht' => 10, 'mittel' => 20, 'schwer' => 30 }
  
  # Debugging-Logs zur Validierung
  Rails.logger.info "Exp values from settings: #{exp_values.inspect}"
  Rails.logger.info "Selected complexity: #{complexity}"

  # Setze die zu erhöhende Erfahrungspunkte, Standardwert 10, falls complexity nicht existiert
  exp_increase = exp_values[complexity] || 10
  Rails.logger.info "Experience increase: #{exp_increase}"

  # Erhöhe die Erfahrung des zugewiesenen Nutzers
  if assigned_to
    Rails.logger.info "Initial EXP: #{assigned_to.exp}, Level: #{assigned_to.level}"
    
    # Erfahrung hinzufügen
    assigned_to.exp += exp_increase

    # Level-Up-Logik
    while assigned_to.exp >= next_level_exp(assigned_to.level)
      Rails.logger.info "Level-Up! Vorheriges Level: #{assigned_to.level}"
      assigned_to.level += 1
      assigned_to.exp -= next_level_exp(assigned_to.level - 1)
      Rails.logger.info "Neues Level: #{assigned_to.level}, Verbleibende EXP: #{assigned_to.exp}"
    end

    # Benutzer speichern
    assigned_to.save
  end
end

# Hilfsmethode, um die benötigten Erfahrungspunkte für das nächste Level zu berechnen
def next_level_exp(level)
  # Beispielhafte Berechnung der nächsten Level-Erfahrungen
  LevelRequirement.find_by(level: level)&.exp_required || (level * 100)
end

end

# Apply patch to Issue model
Issue.include IssuePatch
