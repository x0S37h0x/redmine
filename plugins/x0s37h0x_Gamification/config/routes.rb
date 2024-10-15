RedmineApp::Application.routes.draw do
  resources :level_requirements
  resource :configurations, only: [:edit, :update], controller: 'configurations'
  resources :habits, only: [:index, :create, :update, :destroy]
   resources :daily_todos, only: [:index, :show, :create, :update, :destroy]
  resources :general_todos, only: [:index, :show, :create, :update, :destroy]
  get 'dashboard', to: 'dashboard#index'
  patch 'tasks/:id/toggle_status', to: 'tasks#toggle_status'
end