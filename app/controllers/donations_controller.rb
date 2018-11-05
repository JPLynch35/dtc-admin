
class DonationsController < ApplicationController

  def create
    donation = Donation.create(donation_params)
    if donation.save 
      redirect_to dashboard_path, :alert => "Donation has been added."
    else
      redirect_to dashboard_path, :alert => "Donation was not created."
    end
  end 

  def destroy
    donation = Donation.find(params[:id])
    donation.destroy!
    redirect_to dashboard_path, :notice => "Donation from #{donation.name} was deleted."
  end

  private

  def donation_params
    params.require(:donation).permit(:id, :name, :email, :city, :state, :amount, :date, :donation_type, :stripe_id)
  end
end
