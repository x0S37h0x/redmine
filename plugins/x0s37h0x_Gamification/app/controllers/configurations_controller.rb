class ConfigurationsController < ApplicationController
      layout 'admin'  # Setzt das Admin-Layout für alle Aktionen
  def edit
    @config = GamificationConfig.first || GamificationConfig.new
  end

  def update
    @config = GamificationConfig.first || GamificationConfig.new
    if @config.update(config_params)
      redirect_to edit_configurations_path, notice: 'Einstellungen wurden erfolgreich aktualisiert.'
    else
      render :edit, alert: 'Fehler beim Aktualisieren der Einstellungen.'
    end
  end

  private

  def config_params
    params.require(:gamification_config).permit(:exp_leicht, :exp_mittel, :exp_schwer)
  end
end
