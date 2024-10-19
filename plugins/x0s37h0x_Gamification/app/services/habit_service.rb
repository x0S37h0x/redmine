class HabitService
  def self.load_habits(user)
    Issue.where(tracker: Tracker.find_by(name: 'Gewohnheit'), status: IssueStatus.find_by(name: 'Neu'), assigned_to_id: user.id)
  end

  def self.create_habit(user, habit_params)
    habit = Issue.new(habit_params.to_h)
    habit.tracker = Tracker.find_by(name: 'Gewohnheit')
    habit.author = user
    habit.assigned_to = user
    habit.status = IssueStatus.find_by(name: 'Neu')
    habit
  end
end
