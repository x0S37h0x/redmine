class X0s37h0xGamificationAdminMenuHook < Redmine::Hook::ViewListener
  def view_admin_menu(context = {})
    context[:controller].send(:render_to_string, {
      partial: 'level_requirements/admin_menu_link',
      locals: context
    })
  end
end