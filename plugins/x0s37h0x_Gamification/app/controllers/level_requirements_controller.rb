# plugins/my_plugin/app/controllers/level_requirements_controller.rb
class LevelRequirementsController < ApplicationController
  
    before_action :require_admin
    layout 'admin'
    before_action :set_level_requirement, only: [:edit, :update, :destroy]


  def index
    @level_requirements = LevelRequirement.all
  end

  def new
    @level_requirement = LevelRequirement.new
     Rails.logger.info "Rendering new level requirement form"
    render 'level_requirements/new' # Falls nötig, explizit rendern
  end

  def create
    @level_requirement = LevelRequirement.new(level_requirement_params)
    if @level_requirement.save
      redirect_to level_requirements_path, notice: 'Level-Anforderung hinzugefügt.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @level_requirement.update(level_requirement_params)
      redirect_to level_requirements_path, notice: 'Level-Anforderung aktualisiert.'
    else
      render :edit
    end
  end

  def destroy
    @level_requirement.destroy
    redirect_to level_requirements_path, notice: 'Level-Anforderung gelöscht.'
  end

  private

  def set_level_requirement
    @level_requirement = LevelRequirement.find(params[:id])
  end

  def level_requirement_params
    params.require(:level_requirement).permit(:level, :exp_required)
  end
end