class UsersController < ApplicationController

  #before_action :authenticate_user!

  def edit_address
    @user = current_user
  end

  def update_address
    @user = current_user
    if @user.update(user_address_params)
      redirect_to root_path, notice: 'Address updated successfully'
    else
      render :edit_address
    end
  end

  private

  def user_address_params
    params.require(:user).permit(:address,:province_id)
  end
end
