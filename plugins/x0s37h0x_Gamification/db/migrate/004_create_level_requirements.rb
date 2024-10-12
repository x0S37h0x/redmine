# plugins/my_plugin/db/migrate/20241012_create_level_requirements.rb
class CreateLevelRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :level_requirements do |t|
      t.integer :level, null: false, unique: true
      t.integer :exp_required, null: false

      t.timestamps
    end
  end
end