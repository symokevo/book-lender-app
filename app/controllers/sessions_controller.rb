class SessionsController < ApplicationController
  before_action :require_authentication, only: :destroy
  before_action :redirect_if_signed_in, only: [:new, :create]

  def new
  end

  def create
    if user = User.authenticate_by(session_params)
      sign_in user
      redirect_to dashboards_path,
      notice: "Welcome #{user.email}!"
    else
      flash.now[:notice] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: "Adios! 👋"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
