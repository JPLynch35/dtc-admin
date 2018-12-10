class UsersController < ApplicationController

  def create
    user = User.create(user_params)
    if user.save 
      redirect_to dashboard_path, :alert => t('dashboard.index.users.crud.add_success', user: user.email)
    else
      redirect_to dashboard_path, :alert => t('dashboard.index.users.crud.add_failure')
    end
  end 

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to dashboard_path, :notice => t('dashboard.index.users.crud.delete_success', user: user.email)
  end

  private

  def user_params
   params.require(:user).permit(:email, :password)
  end
end