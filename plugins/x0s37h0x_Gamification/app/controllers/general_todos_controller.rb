# plugins/x0s37h0x_Gamification/app/controllers/general_todos_controller.rb
class GeneralTodosController < ApplicationController
  before_action :find_general_todo, only: [:show, :update, :destroy]

  def index
    @general_todos = GeneralTodo.all  # Alle allgemeinen To-Dos abrufen
    render json: @general_todos
  end

  def show
    render json: @general_todo
  end

  def create
    @general_todo = GeneralTodo.new(general_todo_params)
    if @general_todo.save
      render json: @general_todo, status: :created
    else
      render json: @general_todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @general_todo.update(general_todo_params)
      render json: @general_todo
    else
      render json: @general_todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @general_todo.destroy
    head :no_content
  end

  private

  def find_general_todo
    @general_todo = GeneralTodo.find(params[:id])
  end

  def general_todo_params
    params.require(:general_todo).permit(:name, :description, :due_date, :completed)
  end
end
