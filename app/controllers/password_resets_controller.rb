class PasswordResetsController < ApplicationController
  before_action :redirect_if_signed_in

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      token = user.generate_token_for(:password_reset)
      UserMailer.with(
        user: user, password_reset_token: token
      )
      .password_reset
      .deliver_now

      redirect_to root_path,
      notice: "Check your email for a password reset link"
    else
      flash.now[:notice] = "Email not found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    user = User.find_by_token_for(
      :password_reset,
      params[:password_reset_token]
    )

    if user.nil?
      flash[:notice] = "Invalid or expired token. Try again."
      redirect_to new_password_reset_path
    elsif user.update(password_reset_params)
      sign_in user
      redirect_to dashboards_path,
      notice: "Password successfully reset"
    else
      flash.now[:notice] = user.errors
      .full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def password_reset_params
    params.require(:password_reset).permit(
      :password, :password_confirmation
    )
  end
end
