class TodoService
  def self.load_todos(user, params)
    todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: user.id)
    todos = todos.where(due_date: Date.today) if params[:filter] == 'today'
    todos = todos.where(project_id: params[:project_id]) if params[:project_id].present?
    todos
  end
def self.load_todos_by_project(user, params)
    todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: user.id)
    todos = todos.where(due_date: Date.today) if params[:filter] == 'today'
    todos = todos.where(project_id: params[:project_id]) if params[:project_id].present?
    
    # Group the todos by project
    todos.group_by(&:project)
  end

  def self.create_todo(user, todo_params)
    todo_params = todo_params.to_h
    todo = Issue.new(todo_params)
    todo.tracker = Tracker.find_by(name: 'ToDo')
    todo.status = IssueStatus.find_by(name: 'Neu')
    todo.author = user
    todo.assigned_to = user
    todo.project = Project.find_by(id: todo_params[:project_id])
    todo
  end
end
