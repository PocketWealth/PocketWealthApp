class AccountsController < ApplicationController
  before_action :logged_in_user
  before_action :set_account, only: %i[ show edit update destroy add_cash remove_cash update_add_cash update_remove_cash transfer_cash update_transfer_cash ]

  # GET /accounts or /accounts.json
  def index
    @accounts = current_user.accounts || []
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    @stocks = @account.stocks
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  def add_cash
    render template: "accounts/add_cash/add_cash"
  end

  def update_add_cash
    @account = AccountUpdatingService.new.add_cash_to_account(@account, account_params)
    respond_to do |format|
      if @account.valid?
        format.html { redirect_to account_url(@account), notice: "Cash added to account" }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_cash
    render template: "accounts/remove_cash/remove_cash"
  end

  def update_remove_cash
    @account = AccountUpdatingService.new.remove_cash_from_account(@account, account_params)
    respond_to do |format|
      if @account.valid?
        format.html { redirect_to account_url(@account), notice: "Cash removed from account" }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def transfer_cash
    @to_accounts = current_user.accounts.reject { |account| account.id == @account.id } || []
    render template: "accounts/transfer_cash/transfer_cash"
  end

  def update_transfer_cash
    @account = AccountUpdatingService.new.transfer_cash(@account, current_user, account_params)
    respond_to do |format|
      if @account.valid?
        format.html { redirect_to account_url(@account), notice: "Cash transferred to account" }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:name, :cash, :description, :financial_institution, :account_type, :to_account_id)
  end
end
