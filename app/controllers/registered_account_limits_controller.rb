class RegisteredAccountLimitsController < ApplicationController
  def new
    @registered_account_limit = RegisteredAccountLimit.new
  end

  def destroy
    @registered_account_limit = RegisteredAccountLimit.find(params[:id]).destroy
    flash[:success] = "RegisteredAccountLimit deleted"
    redirect_to registered_account_limit_url, status: :see_other
  end

  def show
    @registered_account_limit = RegisteredAccountLimit.find(params[:id])
  end

  def create
    @registered_account_limit = RegisteredAccountLimit.new(registered_account_limit_params)
    if @registered_account_limit.save
      flash[:success] = "New registered account limit created!"
      redirect_to @registered_account_limit
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @registered_account_limit = RegisteredAccountLimit.find(params[:id])
  end

  def update
    @registered_account_limit = RegisteredAccountLimit.find(params[:id])
    if @registered_account_limit.update(registered_account_limit_params)
      flash[:success] = "Registered account limit updated!"
      redirect_to @registered_account_limit
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def registered_account_limit_params
    params.require(:registered_account_limit).permit(:name, :email, :password, :password_confirmation)
  end
end
