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

  # Menü im Admin-Bereich hinzufügen
  menu :admin_menu, :x0s37h0x_gamification, { controller: 'level_requirements', action: 'index' }, caption: 'Gamification', html: { class: 'icon icon-settings' }
  menu :admin_menu, :level_requirements, { controller: 'level_requirements', action: 'index' }, caption: 'Level Requirements', parent: :x0s37h0x_gamification
  menu :admin_menu, :x0s37h0x_gamification_config, { controller: 'configurations', action: 'edit' }, caption: 'Gamification Settings', parent: :x0s37h0x_gamification
end

# Initialisiere und lade `exp_values` aus der Datenbank
Rails.configuration.to_prepare do
  # Entferne den Cache und lade die Einstellungen neu
  Rails.cache.delete('plugin_x0s37h0x_Gamification')
  Setting.load_available_settings

  # Einstellungen aus der Datenbank laden und Standardwerte setzen, wenn nicht vorhanden
  raw_settings = Setting.plugin_x0s37h0x_Gamification
  if raw_settings.is_a?(Hash) && raw_settings['exp_values']
    # Konvertiere alle Werte in Integer und setze sie in eine globale Variable
    $exp_values = raw_settings['exp_values'].transform_values(&:to_i)
  else
    $exp_values = { 'leicht' => 10, 'mittel' => 20, 'schwer' => 30 }
  end

  # Logging zur Überprüfung der geladenen Werte
  Rails.logger.debug "Loaded exp_values in init.rb: #{$exp_values.inspect}"
end

# Zusätzliche Assets und Hooks laden
Rails.application.config.assets.precompile += %w(x0s37h0x_Gamification/profile_styles.css)
Rails.autoloaders.main.push_dir("#{__dir__}/lib")

# User- und Issue-Patch laden
require_relative 'lib/user_patch'
require_relative 'lib/issue_patch'
require_relative 'lib/x0s37h0x_Gamification_admin_menu_hook'
require_relative 'lib/x0s37h0x_Gamification_hook' if File.exist?(File.join(__dir__, 'lib', 'x0s37h0x_Gamification_hook.rb'))
