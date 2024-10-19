class HabitsController < ApplicationController
  before_action :find_habit, only: [:update, :destroy]
   def new
    @new_habit = Issue.new
  end


  def create
    @habit = HabitService.create_habit(User.current, habit_params)
    if @habit.save
      render json: { status: "success", message: "Gewohnheit erfolgreich erstellt!", section: 'habits' }
    else
      render json: { status: "error", message: @habit.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    if @habit.update(habit_params)
      render json: { status: "success", message: "Gewohnheit erfolgreich aktualisiert!" }
    else
      render json: { status: "error", message: @habit.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
    @habit.destroy
    head :no_content
  end

  private

  def find_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:issue).permit(:subject, :description)
  end
end
