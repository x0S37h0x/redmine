class DashboardController < ApplicationController
  # These lines would go at the top of the controller file if needed
  require_relative '../services/habit_service'
  require_relative '../services/daily_task_service'
  require_relative '../services/todo_service'

  # Include the helpers required to render tooltips and other issue-related elements
  helper :issues  # This includes IssuesHelper, which contains the render_issue_tooltip method
  helper :custom_fields

  def index
    @new_habit = Issue.new  # Initialize the @new_habit object
    @new_todo = Issue.new #
    @new_daily_task = Issue.new

    @habits = HabitService.load_habits(User.current)
    @daily_tasks = DailyTaskService.load_daily_tasks(User.current)
    expires_now  # Deaktiviert Browser-Cache
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'  # Keine Caching für den Browser
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    @todos_by_project = TodoService.load_todos_by_project(User.current, params)

    @user_projects = Project.joins(:members).where(members: { user_id: User.current.id })

    # Calendar setup
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    @calendar = Redmine::Helpers::Calendar.new(start_date, current_language, :month)
    @calendar.events = Issue.where(due_date: start_date..end_date)

    respond_to do |format|
      format.html
    end
  end

  def user_info
    render partial: 'x0s37h0x_Gamification/user_info_header'
  end

  def update_section
    case params[:section]
    when 'habits'
      @habits = HabitService.load_habits(User.current)
      render partial: 'dashboard/habits_section'

    when 'daily_tasks'
      @daily_tasks = DailyTaskService.load_daily_tasks(User.current)
      render partial: 'dashboard/daily_tasks_section'

    when 'todos'
      todos = TodoService.load_todos(User.current, params)
      @todos_by_project = todos.group_by(&:project)

      # Ensure @user_projects is loaded
      @user_projects = Project.joins(:members).where(members: { user_id: User.current.id })

      render partial: 'dashboard/todos_section'

    else
      head :bad_request
    end
  end
end
