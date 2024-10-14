# plugins/x0s37h0x_Gamification/app/controllers/daily_todos_controller.rb
class DailyTodosController < ApplicationController
  before_action :find_daily_todo, only: [:show, :update, :destroy]

  def index
    @daily_todos = DailyTodo.where(due_date: Date.today)  # Filtere die täglichen Aufgaben für das aktuelle Datum
    render json: @daily_todos
  end

  def show
    render json: @daily_todo
  end

  def create
    @daily_todo = DailyTodo.new(daily_todo_params)
    if @daily_todo.save
      render json: @daily_todo, status: :created
    else
      render json: @daily_todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @daily_todo.update(daily_todo_params)
      render json: @daily_todo
    else
      render json: @daily_todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @daily_todo.destroy
    head :no_content
  end

  private

  def find_daily_todo
    @daily_todo = DailyTodo.find(params[:id])
  end

  def daily_todo_params
    params.require(:daily_todo).permit(:name, :description, :due_date, :completed)
  end
end
