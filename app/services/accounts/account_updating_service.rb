class AccountUpdatingService
  include AccountsHelper

  def initialize(user)
    @user = user
  end

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

  def edit_account_cash(from_account, account_params)
    cash = account_params[:cash].to_d
    edit_type = account_params[:edit_cash_type]
    if edit_type == "add"
      add_cash_to_account(from_account, cash)
    elsif edit_type == "remove"
      remove_cash_from_account(from_account, cash)
    elsif edit_type == "transfer"
      transfer_cash(from_account, account_params)
    else
      raise ActionController::BadRequest
    end
    from_account
  end

  def add_cash_to_account(account, cash)
    return account unless cash.positive?
    total_cash = account.cash + cash
    account.update({ cash: total_cash })
    account
  end

  def remove_cash_from_account(account, cash)
    return account unless cash.positive?
    total_cash = account.cash - cash
    account.update({ cash: total_cash })
    account
  end

  def transfer_cash(from_account, account_params)
    to_account = @user.accounts.find_by(id: account_params[:to_account_id])
    raise ActionController::BadRequest unless valid_transfer_request?(from_account, to_account)
    cash_to_transfer = account_params[:cash].to_d
    return unless cash_to_transfer.positive?
    update_to_account_contributions = should_update_to_account_contributions(from_account, to_account)
    ActiveRecord::Base.transaction do
      update_account_cash(from_account, from_account.cash - cash_to_transfer)
      update_account_cash(to_account, to_account.cash + cash_to_transfer)
      if update_to_account_contributions
        update_account_contributions(to_account, cash_to_transfer)
      end
    end
    from_account
  end

  def update_account_contributions(account, cash)
    registered_accounts = @user.registered_account_limit
    type = "#{account.account_type}_contributions".downcase
    contributions = registered_accounts[type]
    updated_contributions = contributions + cash
    registered_accounts.update({ type => updated_contributions })
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

  def should_update_to_account_contributions(from_account, to_account)
    ACCOUNT_TRANSFER_UPDATE_CONTRIBUTIONS[from_account.account_type][to_account.account_type]
  end
end
