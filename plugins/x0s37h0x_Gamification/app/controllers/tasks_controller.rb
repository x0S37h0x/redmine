# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  def toggle_status
    task = Issue.find(params[:id])
    task.status = params[:status] == 'closed' ? IssueStatus.find_by(name: 'Closed') : IssueStatus.find_by(name: 'Open')
    task.save
    head :ok
  end
end
