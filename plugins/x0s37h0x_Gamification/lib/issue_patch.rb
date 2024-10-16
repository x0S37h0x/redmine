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
    # Retrieve the value of 'Komplexität' custom field
    complexity = custom_field_value(CustomField.find_by_name('Komplexität'))
    
    # Fallback, falls Komplexität nicht vorhanden ist
    unless complexity
      Rails.logger.warn "No complexity found; skipping exp increase."
      return
    end

    # Load exp_values from GamificationConfig
    config = GamificationConfig.first
    exp_values = {
      'leicht' => config&.exp_leicht || 10,
      'mittel' => config&.exp_mittel || 20,
      'schwer' => config&.exp_schwer || 30
    }

    # Logging zur Überprüfung
    Rails.logger.info "Loaded exp_values from GamificationConfig: #{exp_values.inspect}"
    Rails.logger.info "Selected complexity: #{complexity}"

    # Setze die exp_increase basierend auf der Komplexität
    exp_increase = exp_values[complexity] || 10
    Rails.logger.info "Experience increase: #{exp_increase}"

    # Stelle sicher, dass `assigned_to` vorhanden ist
    if assigned_to
      Rails.logger.info "Initial EXP: #{assigned_to.exp}, Level: #{assigned_to.level}"

      # Erfahrungspunkte hinzufügen
      assigned_to.exp += exp_increase

      # Level-Up-Logik
      while assigned_to.exp >= next_level_exp(assigned_to.level)
        Rails.logger.info "Level-Up! Previous level: #{assigned_to.level}"
        assigned_to.level += 1
        assigned_to.exp -= next_level_exp(assigned_to.level - 1)
        Rails.logger.info "New level: #{assigned_to.level}, Remaining EXP: #{assigned_to.exp}"
      end

      # Aktualisiere und speichere den Benutzer
      if assigned_to.save
        Rails.logger.info "User saved successfully with updated EXP and Level."
      else
        Rails.logger.error "Failed to save user: #{assigned_to.errors.full_messages.join(', ')}"
      end
    else
      Rails.logger.warn "No user assigned; cannot increase EXP."
    end
  rescue => e
    Rails.logger.error "Error in increase_user_exp method: #{e.message}"
  end

  # Helper method to calculate the experience required for the next level
  def next_level_exp(level)
    LevelRequirement.find_by(level: level)&.exp_required || (level * 100)
  end
end

# Apply patch to Issue model
Issue.include IssuePatch
