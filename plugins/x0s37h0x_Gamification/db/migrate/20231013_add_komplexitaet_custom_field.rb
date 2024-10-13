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

      # Assign the custom field to the "Tägliche Aufgabe" tracker if it exists
      tracker = Tracker.find_by(name: 'Tägliche Aufgabe')
      complexity_field.trackers << tracker if tracker.present?

      # Assign the custom field to all current projects
      Project.find_each do |project|
        project.issue_custom_fields << complexity_field unless project.issue_custom_fields.include?(complexity_field)
      end

      # Ensure the custom field is added to new projects by hooking into the project creation process
      Project.class_eval do
        after_create do
          self.issue_custom_fields << complexity_field unless self.issue_custom_fields.include?(complexity_field)
        end
      end
    end
  end

  def down
    # Remove the "Komplexität" custom field from all projects and destroy it
    complexity_field = CustomField.find_by(name: 'Komplexität', type: 'IssueCustomField')
    if complexity_field
      Project.find_each do |project|
        project.issue_custom_fields.delete(complexity_field)
      end
      complexity_field.destroy
    end
  end
end
