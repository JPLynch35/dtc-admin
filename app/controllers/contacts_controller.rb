class ContactsController < ApplicationController

  def create
    contact = Contact.create(contact_params)
    if contact.save 
      redirect_to dashboard_path, :alert => "#{contact.name} has been added to your contact list."
    else
      redirect_to dashboard_path, :alert => "Contact was not created."
    end
  end 

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy!
    redirect_to dashboard_path, :notice =>  "#{contact.name} has been removed from your contact list."
  end

  private

  def contact_params
   params.require(:contact).permit(:name, :email, :phone, :organization)
  end
end