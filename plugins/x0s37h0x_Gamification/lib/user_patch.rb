# plugins/my_plugin/lib/user_patch.rb
module UserPatch
  extend ActiveSupport::Concern

  included do
    # Deine benutzerdefinierten Felder sind bereits in der Datenbank vorhanden,
    # es sind keine weiteren Definitionen notwendig.
  end

  def avatar_url
        # Verändere die Avatar-URL oder füge Logik hinzu
        super || "/images/default_avatar.png"
  end
  def max_exp
    LevelRequirement.find_by(level: self.level)&.exp_required || 0
  end

end



# Patching des User-Modells
User.include(UserPatch)