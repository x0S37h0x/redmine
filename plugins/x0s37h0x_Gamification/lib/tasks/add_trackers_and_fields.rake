# plugins/x0s37h0x_Gamification/lib/tasks/add_trackers_and_fields.rake
namespace :gamification_plugin do
  desc "Add custom trackers and Komplexität field to all projects"
  task add_trackers_and_fields: :environment do
    # Ensure the trackers exist
    todo_tracker = Tracker.find_or_create_by(name: 'ToDo')
    daily_task_tracker = Tracker.find_or_create_by(name: 'Tägliche Aufgabe')
    habit_tracker = Tracker.find_or_create_by(name: 'Gewohnheit')

    # Ensure the custom field exists
    complexity_field = IssueCustomField.find_by(name: 'Komplexität')
    unless complexity_field
      puts "Custom field 'Komplexität' not found. Please create it manually."
      return
    end

    # Iterate through all projects to add trackers and custom fields
    Project.find_each do |project|
      [todo_tracker, daily_task_tracker, habit_tracker].each do |tracker|
        project.trackers << tracker unless project.trackers.include?(tracker)
      end
      project.issue_custom_fields << complexity_field unless project.issue_custom_fields.include?(complexity_field)
    end
    puts "Trackers and 'Komplexität' field have been added to all projects."
  end
end
