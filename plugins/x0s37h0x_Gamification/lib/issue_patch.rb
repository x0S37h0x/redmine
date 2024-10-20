module IssuePatch
  extend ActiveSupport::Concern

  included do
    # Vor dem Speichern prüfen, ob der Status sich geändert hat
    before_save :store_previous_status
    after_save :adjust_user_exp_based_on_status_change
  end

  private

  # Diese Methode speichert den vorherigen Status der Aufgabe, bevor sie aktualisiert wird
  def store_previous_status
    @previous_status = status_was
  end

  # Diese Methode fügt oder zieht EXP hinzu/ab, basierend auf dem Status der Aufgabe
  def adjust_user_exp_based_on_status_change
    # Prüfe, ob die Aufgabe den Custom Tracker "Tägliche Aufgabe" hat
    return unless tracker.name == 'Tägliche Aufgabe'

     # Skip logic if this is a new task, because no previous status exists
    return if @previous_status.nil?

    # Hole die Komplexität aus dem CustomField
    complexity = custom_field_value(CustomField.find_by_name('Komplexität'))
    return unless complexity # Keine Komplexität definiert, keine Aktion

    # EXP-Konfigurationen laden
    config = GamificationConfig.first
    exp_values = {
      'leicht' => config&.exp_leicht || 10,
      'mittel' => config&.exp_mittel || 20,
      'schwer' => config&.exp_schwer || 30
    }

    exp_change = exp_values[complexity] || 10 # Standardwert 10, falls keine Komplexität gefunden wird

    # Überprüfen, ob der Status von "Erledigt" zu "Neu" gewechselt hat oder umgekehrt
    if status.is_closed? && @previous_status != status # Aufgabe wird geschlossen
      increase_user_exp(exp_change)
    elsif !status.is_closed? && @previous_status.is_closed? # Aufgabe wird von Erledigt auf Neu gesetzt
      decrease_user_exp(exp_change)
    end
  end

  # Diese Methode fügt EXP hinzu
  def increase_user_exp(exp_change)
    if assigned_to
      Rails.logger.info "Erfahrungspunkte hinzugefügt: #{exp_change} EXP"
      assigned_to.exp += exp_change

      # Level-Up-Logik prüfen
      level_up_user_if_needed
    end
  end

  # Diese Methode zieht EXP ab
  def decrease_user_exp(exp_change)
    if assigned_to && assigned_to.exp >= exp_change
      Rails.logger.info "Erfahrungspunkte abgezogen: #{exp_change} EXP"
      assigned_to.exp -= exp_change

      # Nutzer speichern
      assigned_to.save
    end
  end

  # Diese Methode prüft, ob der Benutzer aufsteigen kann
  def level_up_user_if_needed
    while assigned_to.exp >= next_level_exp(assigned_to.level)
      assigned_to.level += 1
      assigned_to.exp -= next_level_exp(assigned_to.level - 1)
    end

    assigned_to.save
  end

  # Methode zur Berechnung der erforderlichen EXP für das nächste Level
  def next_level_exp(level)
    LevelRequirement.find_by(level: level)&.exp_required || (level * 100)
  end
end

# Patch auf das Issue-Modell anwenden
Issue.include IssuePatch
