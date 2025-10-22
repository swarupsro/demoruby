class LabController < ApplicationController
  before_action :require_admin
  before_action :ensure_lab_mode

  def show
    @simulation_config = Rails.application.config.x.lab_simulation
    @probe_log = SimulatedInjectionService.log_entries.reverse
    @override_state = SimulatedInjectionService.override_enabled
  end

  def toggle
    case params[:state]
    when "on"
      SimulatedInjectionService.enable!
      notice = "Simulation explicitly enabled for this server."
    when "off"
      SimulatedInjectionService.disable!
      notice = "Simulation explicitly disabled for this server."
    when "reset"
      SimulatedInjectionService.reset_override!
      notice = "Simulation override reset to environment default."
    when "clear_logs"
      SimulatedInjectionService.clear_log!
      notice = "Simulation probe log cleared."
    else
      notice = "No action taken."
    end

    redirect_to lab_path, notice: notice
  end

  private

  def ensure_lab_mode
    return if Rails.env.lab? || ENV["LAB_MODE"] == "1"

    flash.now[:alert] = "Lab controls are best used in lab mode. Set LAB_MODE=1 to enable full features."
  end
end
