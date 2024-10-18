class DashboardController < ApplicationController
  before_action :ensure_daily_task_project, only: [:index, :create_daily_task]
  helper :issues
  helper :custom_fields

  def index
    @new_habit = Issue.new
    @new_daily_task = Issue.new
    @new_todo = Issue.new

    @user_projects = Project.joins(:members).where(members: { user_id: User.current.id })
    @habits = Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)
    @daily_tasks = Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'), assigned_to_id: User.current.id, status: IssueStatus.find_by(name: 'Neu'))
    todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)
    todos = todos.where(due_date: Date.today) if params[:filter] == 'today'
    todos = todos.where(project_id: params[:project_id]) if params[:project_id].present?
    @todos_by_project = todos.group_by(&:project)

    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    @calendar = Redmine::Helpers::Calendar.new(start_date, current_language, :month)
    @calendar.events = Issue.where(due_date: start_date..end_date)
    
    respond_to do |format|
      format.html # Für normale Anfragen
    end
  end

  def create_habit
    @new_habit = Issue.new(habit_params)
    @new_habit.tracker = Tracker.find_by(name: 'Gewohnheit')
    @new_habit.author = User.current
    @new_habit.assigned_to = User.current
    @new_habit.status = IssueStatus.find_by(name: 'Neu')

    if @new_habit.save
      render json: { status: "success", message: "Gewohnheit erfolgreich erstellt!", section: 'habits' }
    else
      render json: { status: "error", message: @new_habit.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def create_daily_task
    daily_task_project = Project.find_by(identifier: "taegliche-aufgaben-#{User.current.id}")

    @daily_task = Issue.new(daily_task_params.to_h)
    @daily_task.tracker = Tracker.find_by(name: 'Tägliche Aufgabe')
    @daily_task.status = IssueStatus.find_by(name: 'Neu')
    @daily_task.project = daily_task_project
    @daily_task.author = User.current
    @daily_task.assigned_to = User.current

    if @daily_task.save
      render json: { status: "success", message: "Tägliche Aufgabe erfolgreich erstellt!", section: 'daily_tasks' }
    else
      render json: { status: "error", message: @daily_task.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def create_todo
    @todo = Issue.new(todo_params.to_h)

    @todo.tracker = Tracker.find_by(name: 'ToDo')
    @todo.status = IssueStatus.find_by(name: 'Neu')

    project = Project.find_by(id: todo_params[:project_id])
    if project.nil?
      render json: { status: "error", message: "Kein Projekt gefunden!" }, status: :unprocessable_entity and return
    end
    @todo.project = project
    @todo.author = User.current
    @todo.assigned_to = User.current

    if @todo.save
      render json: { status: "success", message: "ToDo erfolgreich erstellt!", section: 'todos' }
    else
      render json: { status: "error", message: @todo.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update_section
  case params[:section]
  when 'habits'
    @habits = Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)
    render partial: 'dashboard/habits_section'
  
  when 'daily_tasks'
    @daily_tasks = Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'), assigned_to_id: User.current.id, status: IssueStatus.find_by(name: 'Neu'))
    render partial: 'dashboard/daily_tasks_section'
  
  when 'todos'
    todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)
    todos = todos.where(due_date: Date.today) if params[:filter] == 'today'
    todos = todos.where(project_id: params[:project_id]) if params[:project_id].present?
    @todos_by_project = todos.group_by(&:project)

    # Ensure @user_projects is loaded to prevent errors in view
    @user_projects = Project.joins(:members).where(members: { user_id: User.current.id })
    
    render partial: 'dashboard/todos_section'
  
  else
    head :bad_request
  end
end



  private

  def ensure_daily_task_project
    User.current.ensure_daily_task_project_exists
  end

  def habit_params
    params.require(:issue).permit(:subject, :description)
  end

  def daily_task_params
    params.require(:issue).permit(:subject, :description)
  end

  def todo_params
    params.require(:issue).permit(:subject, :description, :project_id, :priority_id)
  end
end
