# plugins/x0s37h0x_Gamification/app/controllers/configurations_controller.rb
class ConfigurationsController < ApplicationController
  # Setzt sicher, dass nur Administratoren Zugriff haben
  before_action :require_admin

  def edit
    @config = GamificationConfig.first_or_initialize
  end

  def update
    @config = GamificationConfig.first_or_initialize
    if @config.update(config_params)
      flash[:notice] = "Einstellungen erfolgreich gespeichert."
      redirect_to action: :edit
    else
      flash[:error] = "Fehler beim Speichern der Einstellungen."
      render :edit
    end
  end

  private

  def config_params
    params.require(:gamification_config).permit(:exp_leicht, :exp_mittel, :exp_schwer)
  end
end
