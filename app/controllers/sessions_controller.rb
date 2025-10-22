class SessionsController < ApplicationController
  before_action :redirect_if_signed_in, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to todos_path, notice: "Signed in successfully."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Signed out successfully."
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def redirect_if_signed_in
    return unless user_signed_in?

    redirect_to todos_path, notice: "You are already signed in."
  end
end
