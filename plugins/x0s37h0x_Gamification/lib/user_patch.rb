# plugins/x0s37h0x_Gamification/lib/user_patch.rb
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

  # Fetches the EXP required for the next level
  def max_exp
    LevelRequirement.find_by(level: self.level + 1)&.exp_required || 0
  end

  # Checks if the user can level up based on current EXP
  def check_level_up
    while self.exp >= max_exp && max_exp > 0
      self.exp -= max_exp   # Subtracts the EXP required for the current level
      self.level += 1        # Increases the level
    end
    save
  end
end

# Apply the User model patch
User.include(UserPatch)
