class UsersController < ApplicationController
  before_action :redirect_if_signed_in, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to todos_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_if_signed_in
    return unless user_signed_in?

    redirect_to todos_path, notice: "You are already signed in."
  end
end
