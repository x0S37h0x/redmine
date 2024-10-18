module UserPatch
  extend ActiveSupport::Concern

  included do
    after_create :create_daily_tasks_project # Callback zum Erstellen des Projekts
  end

  def avatar_url
    super || ActionController::Base.helpers.asset_path('images/default_avatar.png')
  end

  # Fetches the EXP required for the next level
  def max_exp
    LevelRequirement.find_by(level: self.level + 1)&.exp_required || 0
  end

  # Checks if the user can level up based on current EXP
  def check_level_up
    while self.exp >= max_exp && max_exp > 0
      self.exp -= max_exp   # Subtracts the EXP required for the current level
      self.level += 1        # Increases the level
    end
    save
  end

  # Stellt sicher, dass das tägliche Aufgabenprojekt existiert, und erstellt es bei Bedarf
  def ensure_daily_task_project_exists
    daily_task_project = Project.find_by(identifier: "taegliche-aufgaben-#{self.id}")

    unless daily_task_project
      daily_task_project = create_daily_tasks_project # Falls nicht vorhanden, erstelle es
    end

    daily_task_project # Gibt das Projekt zurück
  end

  private

  # Methode zum Erstellen des persönlichen "Tägliche Aufgaben"-Projekts
  def create_daily_tasks_project
    project = Project.create!(
      name: "Tägliche Aufgaben für #{self.login}",
      identifier: "taegliche-aufgaben-#{self.id}",
      is_public: false,  # Stelle sicher, dass das Projekt nicht öffentlich ist
      enabled_module_names: ['issue_tracking']  # Nur Module, die du benötigst
    )

    # Füge den Benutzer als Mitglied hinzu
    Member.create!(
      user: self,
      project: project,
      roles: [Role.find_by(name: 'Entwickler')]  # oder andere passende Rolle
    )

    # Tracker hinzufügen (optional)
    add_trackers_to_project(project)

    project # Gib das erstellte Projekt zurück
  end

  # Methode zum Hinzufügen von Trackern zum Projekt
  def add_trackers_to_project(project)
    todo_tracker = Tracker.find_or_create_by!(name: 'ToDo')
    daily_task_tracker = Tracker.find_or_create_by!(name: 'Tägliche Aufgabe')

    project.trackers << todo_tracker unless project.trackers.include?(todo_tracker)
    project.trackers << daily_task_tracker unless project.trackers.include?(daily_task_tracker)
  end
end

# Apply the User model patch
User.include(UserPatch)
