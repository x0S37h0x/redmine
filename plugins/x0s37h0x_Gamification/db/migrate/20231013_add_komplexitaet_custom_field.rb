# plugins/x0s37h0x_Gamification/db/migrate/20231013_add_komplexitaet_custom_field.rb
class AddKomplexitaetCustomField < ActiveRecord::Migration[6.0]
  def up
    # Create the "Komplexität" custom field if it doesn't already exist
    unless CustomField.exists?(name: 'Komplexität', type: 'IssueCustomField')
      complexity_field = IssueCustomField.create!(
        name: 'Komplexität',
        field_format: 'list',
        possible_values: ['leicht', 'mittel', 'schwer'],
        is_required: false,
        is_filter: true,
        searchable: true,
        default_value: 'leicht'
      )

      # Assign the custom field to specific trackers, e.g., "Tägliche Aufgabe"
      tracker = Tracker.find_by(name: 'Tägliche Aufgabe')
      complexity_field.trackers << tracker if tracker.present?
    end
  end

  def down
    # Remove the "Komplexität" custom field on rollback
    CustomField.find_by(name: 'Komplexität', type: 'IssueCustomField')&.destroy
  end
end
