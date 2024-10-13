RedmineApp::Application.routes.draw do
  resources :level_requirements
    resource :configurations, only: [:edit, :update], controller: 'configurations'
end