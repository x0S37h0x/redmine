class AddGewohnheitTracker < ActiveRecord::Migration[7.2]
  def up
    # Standardstatus für den Tracker festlegen
    default_status = IssueStatus.order(:id).first

    # Erstelle den "Gewohnheit"-Tracker, falls er nicht existiert
    gewohnheit_tracker = Tracker.find_or_create_by!(name: 'Gewohnheit') do |tracker|
      tracker.default_status = default_status
    end

    # Standard-Workflow für alle benutzerdefinierten Rollen und Status hinzufügen
    roles = Role.where(builtin: 0)  # Nur benutzerdefinierte Rollen
    roles.each do |role|
      IssueStatus.all.each do |old_status|
        IssueStatus.all.each do |new_status|
          WorkflowTransition.find_or_create_by!(
            role: role,
            tracker: gewohnheit_tracker,
            old_status: old_status,
            new_status: new_status
          )
        end
      end
    end

    # Füge den Tracker zu allen Projekten hinzu
    Project.find_each do |project|
      project.trackers << gewohnheit_tracker unless project.trackers.include?(gewohnheit_tracker)
    end
  end

  def down
    # Entferne den Gewohnheit-Tracker aus allen Projekten und lösche ihn
    gewohnheit_tracker = Tracker.find_by(name: 'Gewohnheit')
    if gewohnheit_tracker
      # Lösche alle zugehörigen Workflow-Übergänge
      WorkflowTransition.where(tracker_id: gewohnheit_tracker.id).destroy_all

      # Entferne den Tracker aus allen Projekten
      Project.find_each { |project| project.trackers.delete(gewohnheit_tracker) }
      
      # Lösche den Tracker
      gewohnheit_tracker.destroy
    end
  end
end
