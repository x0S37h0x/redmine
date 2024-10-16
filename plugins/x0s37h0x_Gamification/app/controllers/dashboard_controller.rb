# In dashboard_controller.rb
require 'icalendar'
class DashboardController < ApplicationController
  helper :issues # This makes Issue helper methods available in the view
  helper :custom_fields # Includes custom field helpers, which might also be required

  def index
    # Get all projects the current user is a member of
    @user_projects = Project.joins(:members).where(members: { user_id: User.current.id })

    # Filter habits by assigned user and 'Neu' status
    @habits = Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)

    # Filter daily tasks by assigned user and 'Neu' status
    @daily_tasks = Issue.where(tracker: Tracker.find_by(name: 'Tägliche Aufgabe'), assigned_to_id: User.current.id, status: IssueStatus.find_by(name: 'Neu'))

    # Base query for todos assigned to the current user with 'Neu' status
    todos = Issue.where(tracker: Tracker.find_by(name: 'ToDo'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: User.current.id)

    # Filter by due date if specified
    todos = todos.where(due_date: Date.today) if params[:filter] == 'today'

    # Filter by selected project if a project_id is provided in the params
    todos = todos.where(project_id: params[:project_id]) if params[:project_id].present?

    # Group todos by project for display in the view
    @todos_by_project = todos.group_by(&:project)

    # Initialize calendar instance for the calendar view
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    @calendar = Redmine::Helpers::Calendar.new(start_date, current_language, :month)
    @calendar.events = Issue.where(due_date: start_date..end_date)
  end

   def calendar_ics
    @events = Issue.where(due_date: Date.today..(Date.today + 1.month)) # Adjust as needed

    calendar = Icalendar::Calendar.new
    @events.each do |event|
      calendar.event do |e|
        e.dtstart     = event.due_date.strftime("%Y%m%dT%H%M%S")
        e.dtend       = event.due_date.strftime("%Y%m%dT%H%M%S")
        e.summary     = event.subject
        e.description = event.description
        e.location    = event.project.name
      end
    end

    calendar.publish
    response.headers['Content-Type'] = 'text/calendar'
    render plain: calendar.to_ical
  end

end
