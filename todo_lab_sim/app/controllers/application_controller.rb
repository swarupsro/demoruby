class ApplicationController < ActionController::Base
  before_action :set_lab_headers

  private

  def set_lab_headers
    return unless lab_mode?

    response.set_header("X-Lab-Mode", "enabled")
  end

  def lab_mode?
    Rails.application.config.x.lab_mode_enabled
  end
end
