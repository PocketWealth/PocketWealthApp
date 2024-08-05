module UsersHelper
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end

  def accounts_for_user(user)
    user.accounts.map { |account| account.id }
  end
end
