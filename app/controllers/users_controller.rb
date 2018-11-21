class UsersController < ApplicationController

  def create
    user = User.create(user_params)
    if user.save 
      redirect_to dashboard_path, :alert => "#{user.email} now has access to the Dress The Child donations dashboard."
    else
      redirect_to dashboard_path, :alert => "User was not created."
    end
  end 

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to dashboard_path, :notice => "#{user.email} no longer has access to the Dress The Child donations dashboard."
  end

  private

  def user_params
   params.require(:user).permit(:email, :password)
  end
end