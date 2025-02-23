class TransactionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_transaction, only: %i[ show edit update destroy ]
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
    unless user_owns_account?(transaction_params[:from_account_id]) && user_owns_account?(transaction_params[:to_account_id])
      flash.now[:danger] = "Something went wrong, please reload the page and try again" # Not quite right!
      render "new", status: :unprocessable_entity
      return
    end
    @transaction = Transaction.new(transaction_params)
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_url(@transaction), notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update

  end

  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
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
    params.require(:transaction).permit(:type,
                                        :transaction_type,
                                        :transaction_date,
                                        :funds_value_added,
                                        :funds_value_removed,
                                        :funds_value_transferred,
                                        :stock_symbol,
                                        :stock_quantity,
                                        :stock_value_added,
                                        :stock_value_removed,
                                        :stock_value_transferred,
                                        :from_account_id,
                                        :to_account_id)
  end
end
