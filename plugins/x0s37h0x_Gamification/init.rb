Redmine::Plugin.register :x0s37h0x_Gamification do
  name 'x0s37h0x_Gamification'
  author 'x0s37h0x'
  description 'Dies ist ein Plugin welches Gamification in Redmine einbaut.'
  version '0.0.1'
  url 'https://x0s37h0x.com/x0s37h0x_Gamification'
  author_url 'https://x0s37h0x.com/about'
  
  # Define default settings if they are not set yet
    settings default: { 'exp_values' => { 'leicht' => 10, 'mittel' => 20, 'schwer' => 30 } },
           partial: 'settings/x0s37h0x_Gamification_settings'
 

    # Hauptmenüpunkt für das Plugin im Admin-Menü
  menu :admin_menu, :x0s37h0x_gamification, { controller: 'level_requirements', action: 'index' }, caption: 'Gamification', html: { class: 'icon icon-settings' }

  # Untermenüpunkt für das Level Requirements im Plugin-Menü
  menu :admin_menu, :level_requirements, { controller: 'level_requirements', action: 'index' }, caption: 'Level Requirements', parent: :x0s37h0x_gamification
   

end
Rails.logger.debug "Plugin settings: #{Setting.plugin_x0s37h0x_Gamification.inspect}" 
Setting.serialize :value, coder: JSON
# Ensure plugin settings are loaded correctly
Rails.cache.delete('plugin_x0s37h0x_Gamification')
Setting.load_available_settings

# Im Controller oder Plugin-Initialisierungsfile
def load_exp_values
  exp_values_yaml = Setting.plugin_x0s37h0x_Gamification
  exp_values_hash = YAML.safe_load(exp_values_yaml['exp_values']) rescue { 'leicht' => 10, 'mittel' => 20, 'schwer' => 30 }
  exp_values_hash.transform_values!(&:to_i) # Optional: Werte in Integer umwandeln
  exp_values_hash
end

#Rails.logger.info "Current Gamification EXP Settings: #{Setting.plugin_x0s37h0x_Gamification['exp_values']}"



Rails.configuration.to_prepare do
  ActiveRecord::MigrationContext.new(File.join(File.dirname(__FILE__), 'db', 'migrate')).migrate
end


Rails.application.config.assets.precompile += %w(x0s37h0x_Gamification/profile_styles.css)

# Autoloader anweisen, das lib-Verzeichnis zu laden (falls notwendig für Rails 6+)
Rails.autoloaders.main.push_dir("#{__dir__}/lib")

# User-Patch laden
require_relative 'lib/user_patch'
require_relative 'lib/x0s37h0x_Gamification_admin_menu_hook'
require_relative 'lib/issue_patch'

# Falls Hooks verwendet werden sollen, laden wir sie hier
require_relative 'lib/x0s37h0x_Gamification_hook' if File.exist?(File.join(__dir__, 'lib', 'x0s37h0x_Gamification_hook.rb'))
require_relative 'lib/x0s37h0x_Gamification_admin_menu_hook' if File.exist?(File.join(__dir__, 'lib', 'x0s37h0x_Gamification_admin_menu_hook.rb'))