module UserHelpers
  def login(user)
    post login_path, params: { session: { email: user.email,
                                          password: "password" } }
  end
end
