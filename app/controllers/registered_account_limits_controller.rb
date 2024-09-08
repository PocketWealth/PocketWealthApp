class RegisteredAccountLimitsController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :set_registered_account_limit
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

  # def create
  #   @registered_account_limit = RegisteredAccountLimit.new(registered_account_limit_params)
  #   if @registered_account_limit.save
  #     flash[:success] = "New registered account limit created!"
  #     redirect_to @registered_account_limit
  #   else
  #     render "new", status: :unprocessable_entity
  #   end
  # end

  def edit
    @edit_type = params.require(:edit_type)
    unless %w[rrsp_limit fhsa_limit tfsa_limit rrsp_contributions fhsa_contributions tfsa_contributions].include?(@edit_type)
      redirect_to registered_account_limits_url, status: :see_other
    end
  end

  def update
    @registered_account_limit = RegisteredAccountLimit.find(params[:id])
    if @registered_account_limit.update(registered_account_limit_params)
      flash[:success] = "Registered account limit updated!"
      render "index", status: :see_other
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def registered_account_limit_params
    params.require(:registered_account_limit).permit(:rrsp_limit, :tfsa_limit, :rrsp_contributions, :tfsa_contributions, :fhsa_limit, :fhsa_contributions)
  end

  def set_registered_account_limit
    @registered_account_limit = RegisteredAccountLimit.find_or_create_by(id: @user.id) do |registered_account_limit|
      registered_account_limit.user_id = @user.id
      registered_account_limit.save
    end
  end

  def set_user
    @user = current_user
  end
end
