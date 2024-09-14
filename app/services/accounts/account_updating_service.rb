class AccountUpdatingService
  include AccountsHelper
  ACCOUNT_TRANSFER_UPDATE_CONTRIBUTIONS = {
    "NON_REGISTERED" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => true,
      "FHSA" => true
    },
    "RRSP" => {
      "NON_REGISTERED" => false,
      "RRSP" => false,
      "TFSA" => true,
      "FHSA" => true
    },
    "TFSA" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => false,
      "FHSA" => true
    },
    "FHSA" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => true,
      "FHSA" => false
    }
  }.freeze

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

  def transfer_cash(from_account, current_user, account_params)
    to_account = current_user.accounts.find_by(id: account_params[:to_account_id])
    raise ActionController::BadRequest unless valid_transfer_request?(from_account, to_account)
    cash_to_transfer = account_params[:cash].to_d
    return unless cash_to_transfer.positive?
    update_to_account_contributions = should_update_to_account_contributions(from_account, to_account)
    ActiveRecord::Base.transaction do
      update_account_cash(from_account, from_account.cash - cash_to_transfer)
      update_account_cash(to_account, to_account.cash + cash_to_transfer)
      if update_to_account_contributions
        update_account_contributions(to_account, cash_to_transfer, current_user)
      end
    end
    from_account
  end

  private

  def valid_transfer_request?(from_account, to_account)
    return false if from_account.nil? || to_account.nil?
    return false if from_account == to_account
    true
  end

  def update_account_cash(account, cash)
    account.update({ cash: cash })
  end

  def update_account_contributions(account, cash, current_user)
    registered_accounts = current_user.registered_account_limit
    type = "#{account.account_type}_contributions".downcase
    contributions = registered_accounts[type]
    updated_contributions = contributions + cash
    registered_accounts.update({ type => updated_contributions })
  end

  def should_update_to_account_contributions(from_account, to_account)
    ACCOUNT_TRANSFER_UPDATE_CONTRIBUTIONS[from_account.account_type][to_account.account_type]
  end
end
