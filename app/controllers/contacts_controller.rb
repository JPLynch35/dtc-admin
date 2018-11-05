class ContactsController < ApplicationController

  def create
    contact = Contact.create(contact_params)
    if contact.save 
      redirect_to dashboard_path, :alert => "Contact created."
    else
      redirect_to dashboard_path, :alert => "Contact was not created."
    end
  end 

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy!
    redirect_to dashboard_path, :notice => "Contact deleted."
  end

  private

  def contact_params
   params.require(:contact).permit(:name, :email, :phone, :organization)
  end
end