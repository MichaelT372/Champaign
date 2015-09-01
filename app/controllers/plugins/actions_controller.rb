class Plugins::ActionsController < ApplicationController
  before_filter :find_form

  def update
    @plugin = Plugins::Action.find(params[:id])
    @plugin.update_attributes(permitted_params)
    @campaign_page = @plugin.campaign_page

    respond_to do |format|
      format.html { render 'plugins/show' }
      format.json { render json: action, status: :ok }
    end
  end

  private

  def find_form
    if params[:plugins_action][:form_id]
      Form.find params[:plugins_action][:form_id]
    end
  end

  def permitted_params
    params.require(:plugins_action).
      permit(:description, :active)
  end
end