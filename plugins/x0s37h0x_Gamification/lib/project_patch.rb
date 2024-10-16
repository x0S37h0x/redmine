# Datei: project_patch.rb

module ProjectPatch
    Rails.logger.info 'ProjectPatch wurde erfolgreich geladen' if defined?(ProjectPatch)

  def self.included(base)
    base.class_eval do
      after_create :add_default_trackers_and_custom_fields
    end
  end

  private

  def add_default_trackers_and_custom_fields
    project = self

    # Log-Ausgabe zum Testen, ob die Methode aufgerufen wird
    Rails.logger.info "Methode add_default_trackers_and_custom_fields wurde aufgerufen für Projekt #{project.name} (ID: #{project.id})"

    begin
      # Standard-Tracker definieren und erstellen, falls sie noch nicht existieren
      trackers = ['ToDo', 'Tägliche Aufgabe', 'Gewohnheit'].map do |tracker_name|
        Tracker.find_or_create_by(name: tracker_name)
      end

      # Log-Ausgabe der hinzugefügten Tracker
      Rails.logger.info "Hinzugefügte Tracker: #{trackers.map(&:name).join(', ')}"

      # Custom Field 'Komplexität' definieren und erstellen, falls es noch nicht existiert
      custom_field = IssueCustomField.find_by(name: 'Komplexität')
      if custom_field.nil?
        custom_field = IssueCustomField.create(
          name: 'Komplexität',
          field_format: 'list',
          possible_values: ['leicht', 'mittel', 'schwer'],
          is_for_all: true,
          tracker_ids: Tracker.pluck(:id)
        )
        Rails.logger.info "Custom Field 'Komplexität' erstellt mit Werten: #{custom_field.possible_values.join(', ')}"
      else
        Rails.logger.info "Custom Field 'Komplexität' bereits vorhanden"
      end

      # Tracker und Custom Field zum Projekt hinzufügen
      project.trackers << trackers
      project.issue_custom_fields << custom_field

      Rails.logger.info "Erfolgreich Tracker und Custom Field 'Komplexität' zum Projekt hinzugefügt"
    rescue => e
      Rails.logger.error "Fehler beim Hinzufügen von Trackern und Custom Fields: #{e.message}"
      e.backtrace.each { |line| Rails.logger.error line }
    end
  end
end

# Den Patch auf das Project-Modell anwenden
Rails.configuration.to_prepare do
  Project.include ProjectPatch
end
