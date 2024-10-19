class DailyTasksController < ApplicationController
  before_action :find_daily_task, only: [:update, :destroy, :complete, :edit]

  def create
    @daily_task = DailyTaskService.create_daily_task(User.current, daily_task_params)
    if @daily_task.save
      render json: { status: "success", message: "Tägliche Aufgabe erfolgreich erstellt!", section: 'daily_tasks' }
    else
      render json: { status: "error", message: @daily_task.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

   def edit
    result = DailyTaskService.load_daily_task_for_edit(params[:id])

    if result[:status] == 'success'
      render json: {
        id: result[:task].id,
        subject: result[:task].subject,
        description: result[:task].description,
        due_date: result[:task].due_date
      }
    else
      render json: { status: 'error', message: result[:message] }, status: :not_found
    end
  end



   def update
    result = DailyTaskService.update_daily_task(params[:id], daily_task_params)

    if result[:status] == 'success'
      render json: { status: 'success', task: result[:task] }
    else
      render json: { status: 'error', message: result[:message] }, status: :unprocessable_entity
    end
  end

  def complete
    if @daily_task
      # Status aktualisieren
      if params[:status] == 'Erledigt'
        @daily_task.status = IssueStatus.find_by(name: 'Erledigt')
      else
        @daily_task.status = IssueStatus.find_by(name: 'Neu')
      end

    

      # Speichern
      if @daily_task.save && @daily_task.assigned_to.save
        render json: { status: 'success', message: 'Aufgabe erfolgreich aktualisiert' }
      else
        render json: { status: 'error', message: 'Fehler beim Speichern der Aufgabe' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'Aufgabe nicht gefunden' }, status: :not_found
    end
  end

  def destroy
    @daily_task.destroy
    head :no_content
  end

  private

  def find_daily_task
  @daily_task = Issue.find_by(id: params[:id], tracker_id: Tracker.find_by(name: 'Tägliche Aufgabe').id)

  if @daily_task && @daily_task.assigned_to == User.current
    return @daily_task
  else
    Rails.logger.error "Aufgabe nicht gefunden!"
    render json: { status: "error", message: "Tägliche Aufgabe nicht gefunden" }, status: :not_found
  end
end






  def daily_task_params
    params.require(:issue).permit(:subject, :description, :due_date)
  end
end
