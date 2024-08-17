class StocksController < ApplicationController
  before_action :logged_in_user
  before_action :set_stock, only: %i[ show edit update destroy delete ]
  before_action :set_user
  before_action :set_accounts


  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
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

  # POST /stocks or /stocks.json
  def create
    params = stock_params
    @stock = Stock.new(params)
    unless user_owns_account?(params[:account_id])
      flash.now[:danger] = "Something went wrong, please reload the page and try again" # Not quite right!
      render "new", status: :unprocessable_entity
      return
    end
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
    StockDeletingService.new.delete_stock(
      @stock, stock_params
    )

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
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
                                    :symbol_id)
    end
end
