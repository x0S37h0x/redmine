# plugins/my_plugin/app/models/level_requirement.rb
class LevelRequirement < ActiveRecord::Base
  validates :level, presence: true, uniqueness: true
  validates :exp_required, presence: true
end