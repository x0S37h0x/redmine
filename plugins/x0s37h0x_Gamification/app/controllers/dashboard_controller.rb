class DashboardController < ApplicationController
  def index
    @habits = Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'), status: IssueStatus.find_by(name: 'Neu'))
    @todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'))
    @daily_tasks = Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'), status: IssueStatus.find_by(name: 'Neu'))
  end
end
