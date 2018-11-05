class UsersController < ApplicationController

  def create
    user = User.create(user_params)
    if user.save 
      redirect_to dashboard_path, :alert => "User created."
    else
      redirect_to dashboard_path, :alert => "User was not created."
    end
  end 

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to dashboard_path, :notice => "User deleted."
  end

  private

  def user_params
   params.require(:user).permit(:email, :password)
  end
end