# plugins/my_plugin/db/migrate/003_add_custom_fields_to_users.rb
class AddCustomFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :leben, :integer, default: 100
    add_column :users, :exp, :integer, default: 0
    add_column :users, :mana, :integer, default: 100
    add_column :users, :level, :integer, default: 1
    add_column :users, :avatar_url, :string 
     add_column :users, :session_token, :string
  end
end