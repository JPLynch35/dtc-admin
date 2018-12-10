class ContactsController < ApplicationController

  def create
    contact = Contact.create(contact_params)
    if contact.save 
      redirect_to dashboard_path, :alert => t('dashboard.index.contacts.crud.add_success', name: contact.name)
    else
      redirect_to dashboard_path, :alert => t('dashboard.index.contacts.crud.add_failure')
    end
  end 

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy!
    redirect_to dashboard_path, :notice =>  t('dashboard.index.contacts.crud.delete_success', name: contact.name)
  end

  private

  def contact_params
   params.require(:contact).permit(:name, :email, :phone, :organization)
  end
end