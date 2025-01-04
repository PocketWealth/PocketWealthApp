class TransactionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_transaction, only: %i[ show edit update]
  before_action :set_user
  before_action :set_accounts


  # GET /transactions or /transactions.json
  def index
    all_transactions = []
    current_user.accounts.each do |account|
      all_transactions += account.transactions
    end
    @transactions = all_transactions
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create

  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update

  end

  def delete
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def set_accounts
    @accounts = @user.accounts
  end

  def set_user
    @user = current_user
  end

  def user_owns_account?(account_id)
    accounts = accounts_for_user(@user)
    accounts.include?(Integer(account_id))
  rescue TypeError
    false
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:type)
  end
end
