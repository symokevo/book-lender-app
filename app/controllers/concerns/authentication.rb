module Authentication
  def require_authentication
    restore_authentication || request_authentication
  end

  def restore_authentication
    Current.user = User.find_by(id: cookies[:user_id])
  end

  def request_authentication
    redirect_to new_session_path,
    notice: "Please sign in to continue"
  end

  def sign_in(user)
    # signin logic here
    cookies[:user_id] = user.id
  end
end
