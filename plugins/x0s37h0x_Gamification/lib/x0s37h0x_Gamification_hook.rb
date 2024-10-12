# plugins/my_plugin/lib/my_plugin_hooks.rb
class X0s37h0xGamificationHook < Redmine::Hook::ViewListener
  # Fügt die neuen Felder unterhalb der User-Informationen im Profil hinzu
  Rails.logger.info "Der Hook wird ausgeführt"
  render_on :view_layouts_base_html_head, inline: '<%= stylesheet_link_tag "profile_styles", plugin: :x0s37h0x_Gamification %>'
  render_on :view_layouts_base_body_top, partial: 'x0s37h0x_Gamification/user_info_header'
  #render_on :view_account_left_bottom, partial: 'users/custom_fields'
end