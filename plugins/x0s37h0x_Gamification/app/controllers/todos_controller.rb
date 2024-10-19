class TodosController < ApplicationController
  before_action :find_todo, only: [:update, :destroy]

  def create
    @todo = TodoService.create_todo(User.current, todo_params)
    if @todo.save
      render json: { status: "success", message: "ToDo erfolgreich erstellt!", section: 'todos' }
    else
      render json: { status: "error", message: @todo.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: { status: "success", message: "ToDo erfolgreich aktualisiert!" }
    else
      render json: { status: "error", message: @todo.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

   def complete
    @todo.status = 'Erledigt' # Update the status to "Erledigt"
    if @todo.save
      render json: { status: "success", message: "ToDo erfolgreich erledigt!" }
    else
      render json: { status: "error", message: @todo.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def find_todo
    @todo = Issue.find_by(id: params[:id], tracker: Tracker.find_by(name: 'ToDo'), assigned_to: current_user)
  end

  def todo_params
    params.require(:issue).permit(:subject, :description, :project_id, :priority_id)
  end
end
