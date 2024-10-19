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
end
