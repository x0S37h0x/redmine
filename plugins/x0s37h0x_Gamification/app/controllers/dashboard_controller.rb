class DashboardController < ApplicationController
  def index
    @daily_tasks = Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'))
    @todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'))
    @habits = Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'))
  end
end
