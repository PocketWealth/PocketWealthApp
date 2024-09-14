class AccountsController < ApplicationController
  before_action :logged_in_user
  before_action :set_account, only: %i[ show edit update destroy edit_cash update_edit_cash ]

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

  def edit_cash
    @edit_type = params.require(:edit_type)
    unless %w[add remove transfer].include?(@edit_type)
      redirect_to accounts_path, status: :see_other
      return
    end
    if @edit_type == "transfer"
      @to_accounts = current_user.accounts.reject { |account| account.id == @account.id } || []
    end
    render template: "accounts/edit_cash/edit_cash"
  end

  def update_edit_cash
    @account = AccountUpdatingService.new.edit_account_cash(@account, current_user, account_params)
    respond_to do |format|
      if @account.valid?
        format.html { redirect_to account_url(@account), notice: "Account updated successfully" }
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
    params.require(:account).permit(:name, :cash, :description, :financial_institution, :account_type, :to_account_id, :edit_cash_type)
  end
end
