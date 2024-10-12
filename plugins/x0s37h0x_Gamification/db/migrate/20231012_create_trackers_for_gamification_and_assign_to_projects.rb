class CreateTrackersForGamificationAndAssignToProjects < ActiveRecord::Migration[6.0]
  def up
    # Standardstatus auswählen
    default_status = IssueStatus.order(:id).first

    # Erstelle den "ToDo"-Tracker
    todo_tracker = Tracker.find_or_create_by!(name: 'ToDo', default_status: default_status)

    # Erstelle den "Tägliche Aufgabe"-Tracker
    daily_task_tracker = Tracker.find_or_create_by!(name: 'Tägliche Aufgabe', default_status: default_status)

    # Beispiel für einen Standard-Workflow-Übergang
    roles = Role.where(builtin: 0)  # Nur benutzerdefinierte Rollen

    roles.each do |role|
      [todo_tracker, daily_task_tracker].each do |tracker|
        IssueStatus.all.each do |old_status|
          IssueStatus.all.each do |new_status|
            # Füge Workflow-Übergänge hinzu, die den Übergang zwischen allen Status erlauben
            WorkflowTransition.find_or_create_by!(
              role: role,
              tracker: tracker,
              old_status: old_status,
              new_status: new_status
            )
          end
        end
      end
    end

    # Füge die Tracker zu jedem Projekt hinzu
    Project.find_each do |project|
      [todo_tracker, daily_task_tracker].each do |tracker|
        project.trackers << tracker unless project.trackers.include?(tracker)
      end
    end
  end

  def down
    # Entferne die Tracker und deren zugehörige Workflow-Transitions und Zuordnungen
    ['ToDo', 'Tägliche Aufgabe'].each do |tracker_name|
      tracker = Tracker.find_by(name: tracker_name)
      if tracker
        WorkflowTransition.where(tracker_id: tracker.id).destroy_all
        Project.find_each do |project|
          project.trackers.delete(tracker)
        end
        tracker.destroy
      end
    end
  end
end
