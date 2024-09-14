class AccountUpdatingService
  def update_account(account, account_params)
    account.update(account_params)
  end

  def add_cash_to_account(account, account_params)
    cash_to_add = account_params[:cash].to_d
    return account unless cash_to_add.positive?
    total_cash = account.cash + cash_to_add
    account.update({ cash: total_cash })
    account
  end
  def remove_cash_from_account(account, account_params)
    cash_to_remove = account_params[:cash].to_d
    return account unless cash_to_remove.positive?
    total_cash = account.cash - cash_to_remove
    account.update({ cash: total_cash })
    account
  end
end
