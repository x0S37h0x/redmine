RedmineApp::Application.routes.draw do
  resources :level_requirements
   get 'configurations/edit', to: 'configurations#edit', as: 'edit_gamification_config'
  post 'configurations/update', to: 'configurations#update', as: 'update_gamification_config'
end