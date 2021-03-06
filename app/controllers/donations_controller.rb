class DonationsController < ApplicationController

  def create
    donation = Donation.create(modified_donation_params)
    if donation.save 
      redirect_to dashboard_path, :alert => t('dashboard.index.donations.crud.add_success', name: donation.name)
    else
      redirect_to dashboard_path, :alert => t('dashboard.index.donations.crud.add_failure')
    end
  end 

  def destroy
    donation = Donation.find(params[:id])
    donation.destroy!
    redirect_to dashboard_path, :notice => t('dashboard.index.donations.crud.delete_success', name: donation.name)
  end

  private

  def donation_params
    params.require(:donation).permit(:id, :name, :email, :city, :state, :amount, :date, :donation_type, :stripe_id)
  end

  def modified_donation_params
    updated_params = donation_params
    updated_params[:amount] = (updated_params[:amount].to_i * 100).to_s
    updated_params
  end
end
