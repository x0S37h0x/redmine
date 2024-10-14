# app/controllers/habits_controller.rb
class HabitsController < ApplicationController
  before_action :set_habit, only: [:show, :update, :destroy]

  def index
    @habits = current_user.habits
    render json: @habits
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      render json: @habit, status: :created
    else
      render json: @habit.errors, status: :unprocessable_entity
    end
  end

  # Weitere Actions (show, update, destroy) hier hinzufügen

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:name, :status, :priority)
  end
end

# Wiederholen Sie dies für DailyTodos und GeneralTodos
