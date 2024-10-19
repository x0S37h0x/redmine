RedmineApp::Application.routes.draw do
  resources :level_requirements
  resource :configurations, only: [:edit, :update], controller: 'configurations'
  #resources :habits, only: [:index, :create, :update, :destroy,:edit]
  #resources :daily_todos, only: [:index, :show, :create, :update, :destroy]
  resources :todos, only: [:create,:edit, :update]
  resources :habits, only: [:create, :update, :destroy]
  resources :daily_tasks, only: [:create, :update, :destroy, :complete]

  get 'dashboard', to: 'dashboard#index'
  get '/dashboard/update_section', to: 'dashboard#update_section'
  get 'dashboard/user_info', to: 'dashboard#user_info'

  patch 'tasks/:id/toggle_status', to: 'tasks#toggle_status'
  get 'dashboard/calendar_only', to: 'dashboard#calendar_only'
  get 'dashboard/calendar.ics', to: 'dashboard#calendar_ics', as: 'calendar_ics'
  #post 'dashboard/create_habit', to: 'dashboard#create_habit', as: 'new_habit'
  #post 'dashboard/create_daily_task', to: 'dashboard#create_daily_task', as: 'new_daily_task'
  #post 'dashboard/create_todo', to: 'dashboard#create_todo', as: 'new_todo'
  #post 'todos/create', to: 'todos#create', as: 'new_todo'

  # routes for ToDo
post 'todos/create', to: 'todos#create', as: 'new_todo'
post 'todos/update/:id', to: 'todos#update', as: 'update_todo'
delete 'todos/destroy/:id', to: 'todos#destroy', as: 'destroy_todo'

# routes for Habit
post 'habits/create', to: 'habits#create', as: 'new_habit'
post 'habits/update/:id', to: 'habits#update', as: 'update_habit'
delete 'habits/destroy/:id', to: 'habits#destroy', as: 'destroy_habit'

# routes for DailyTask
post 'daily_tasks/create', to: 'daily_tasks#create', as: 'new_daily_task'
patch 'daily_tasks/update/:id', to: 'daily_tasks#update', as: 'update_daily_task'
delete 'daily_tasks/destroy/:id', to: 'daily_tasks#destroy', as: 'destroy_daily_task'
get 'daily_tasks/:id/edit', to: 'daily_tasks#edit', as: 'edit_daily_task'

patch 'todos/:id/complete', to: 'todos#complete', as: 'complete_todo'
#patch 'daily_tasks/:id/complete', to: 'daily_tasks#complete', as: 'complete_daily_task'
patch 'habits/:id/complete', to: 'habits#complete', as: 'complete_habit'
post 'daily_tasks/:id/complete', to: 'daily_tasks#complete', as: 'complete_daily_task'
end