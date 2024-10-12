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
    # Hole die Komplexität und entsprechenden Exp-Wert aus den Plugin-Einstellungen
    complexity = custom_field_value(CustomField.find_by_name('Komplexität'))
    exp_increase = Setting.plugin_x0s37h0x_Gamification['exp_values'][complexity] || 10

    # Erhöhe die Exp für den Benutzer, wenn einer zugewiesen ist
    if assigned_to
      assigned_to.exp += exp_increase
      assigned_to.save
    end
  end
end

# Patch anwenden
Issue.include IssuePatch
