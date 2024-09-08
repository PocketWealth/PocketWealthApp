module UserHelpers
  def login(user)
    post login_path, params: { session: { email: user.email,
                                          password: "password" } }
  end

  def logout
    delete logout_path
  end

  def is_logged_in?
    !session[:user_id].nil?
  end
end
