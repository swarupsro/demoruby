class ErrorsController < ApplicationController
  skip_before_action :set_lab_headers
  skip_before_action :require_login, raise: false

  def not_found
    render "errors/not_found", status: :not_found, layout: false
  end
end
