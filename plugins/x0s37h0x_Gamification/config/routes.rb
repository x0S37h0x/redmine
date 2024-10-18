RedmineApp::Application.routes.draw do
  resources :level_requirements
  resource :configurations, only: [:edit, :update], controller: 'configurations'
  resources :habits, only: [:index, :create, :update, :destroy]
   resources :daily_todos, only: [:index, :show, :create, :update, :destroy]
  resources :general_todos, only: [:index, :show, :create, :update, :destroy]
  get 'dashboard', to: 'dashboard#index'
  get '/dashboard/update_section', to: 'dashboard#update_section'

  patch 'tasks/:id/toggle_status', to: 'tasks#toggle_status'
  get 'dashboard/calendar_only', to: 'dashboard#calendar_only'
  get 'dashboard/calendar.ics', to: 'dashboard#calendar_ics', as: 'calendar_ics'
  post 'dashboard/create_habit', to: 'dashboard#create_habit', as: 'new_habit'
  post 'dashboard/create_daily_task', to: 'dashboard#create_daily_task', as: 'new_daily_task'
  post 'dashboard/create_todo', to: 'dashboard#create_todo', as: 'new_todo'

  
 
end