class DailyTaskService
  def self.load_daily_tasks(user)
    Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'), assigned_to_id: user.id) #status: IssueStatus.find_by(name: 'Neu')
  end

  def self.create_daily_task(user, daily_task_params)
    daily_task = Issue.new(daily_task_params.to_h)
    
    daily_task.tracker = Tracker.find_by(name: 'Tägliche Aufgabe')
    daily_task.status = IssueStatus.find_by(name: 'Neu')
    daily_task.author = user
    daily_task.assigned_to = user
    daily_task.project = Project.find_by(identifier: "taegliche-aufgaben-#{user.id}")
    daily_task
  end

 # Neue Methode zum Bearbeiten von täglichen Aufgaben
  def self.update_daily_task(task_id, daily_task_params)
    daily_task = Issue.find_by(id: task_id, tracker: Tracker.find_by(name: 'Tägliche Aufgabe'))

    # Fehlerbehandlung, falls die Aufgabe nicht gefunden wird
    return { status: 'error', message: 'Tägliche Aufgabe nicht gefunden' } if daily_task.nil?

    # Update der Aufgabe
    if daily_task.update(daily_task_params.to_h)
      { status: 'success', task: daily_task }
    else
      { status: 'error', message: daily_task.errors.full_messages.join(', ') }
    end
  end

  def self.load_daily_task_for_edit(task_id)
    daily_task = Issue.find_by(id: task_id, tracker: Tracker.find_by(name: 'Tägliche Aufgabe'))

    if daily_task.nil?
      { status: 'error', message: 'Tägliche Aufgabe nicht gefunden' }
    else
      { status: 'success', task: daily_task }
    end
  end

end
