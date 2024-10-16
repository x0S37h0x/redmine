# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  #protect_from_forgery with: :null_session # Erlaubt externe POST/PATCH/DELETE-Anfragen ohne CSRF-Token
  def toggle_status
    task = Issue.find(params[:id])
    
    # Nutze die Statusnamen in Redmine (z.B. "Erledigt" und "Offen")
    new_status = if params[:status] == 'erledigt'
                   IssueStatus.find_by(name: 'Erledigt')
                 else
                   IssueStatus.find_by(name: 'Offen')
                 end

    if new_status && task.update(status: new_status)
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
end
