class StocksController < ApplicationController
  before_action :logged_in_user
  before_action :set_stock, only: %i[ show edit update destroy delete edit_transfer_stock update_transfer_stock]
  before_action :set_user
  before_action :set_accounts


  # GET /stocks or /stocks.json
  def index
    all_stocks = []
    current_user.accounts.each do |account|
      all_stocks += account.stocks
    end
    @stocks = all_stocks
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  def edit_transfer_stock
    from_account = @stock.account
    @to_accounts = current_user.accounts.reject { |account| account.id == from_account.id } || []
  end

  def update_transfer_stock
    account_updating_service = AccountUpdatingService.new(current_user)
    @stock = StockTransferService.new(user: current_user, account_updating_service: account_updating_service)
                                 .transfer_stock(stock: @stock, to_account_id: params[:stock][:to_account_id], quantity: params[:stock][:transfer_quantity].to_d)
    respond_to do |format|
      if @stock.valid?
        format.html { redirect_to stock_path(@stock), notice: "Stock updated successfully" }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /stocks or /stocks.json
  def create
    unless user_owns_account?(stock_params[:account_id])
      flash.now[:danger] = "Something went wrong, please reload the page and try again" # Not quite right!
      render "new", status: :unprocessable_entity
      return
    end
    account_updating_service = AccountUpdatingService.new(current_user)
    @stock = StockCreatingService.new(user: current_user, account_updating_service: account_updating_service)
                                 .create_stock(stock_params, params[:stock][:update_account])
    respond_to do |format|
      if @stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      update_params = stock_params
      update_params = update_params.except(:account_id)
      if @stock.update(update_params)
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    account_updating_service = AccountUpdatingService.new(current_user)
    @stock = StockDeletingService.new(account_updating_service: account_updating_service).delete_stock(
      @stock, stock_params
    )
    respond_to do |format|
      if @stock.destroyed?
        format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
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
    def stock_params
      params.require(:stock).permit(:symbol,
                                    :purchase_date,
                                    :share_price,
                                    :quantity_purchased,
                                    :account_id,
                                    :add_stock_value_to_account,
                                    :to_account_id,
                                    :symbol_id,
                                    :broker)
    end
end
