require 'rails_helper'

describe 'an admin' do
  describe 'visiting the contacts tab' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before :each do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

   it 'can create a contact and delete a contact' do
      expect(Contact.count).to eq(0)
     
      name = 'Bob'
      email = 'Bob@gmail.com'
      phone = '345-654-3245'
      organization = 'Pathmark'
      
      visit dashboard_path
      
      within(:css, "div#contact-form") do
        fill_in 'contact-name', with: name
        fill_in 'contact-email', with: email
        fill_in 'contact-phone', with: phone
        fill_in 'contact-organization', with: organization
      end

      click_on 'Add Contact'

      expect(Contact.count).to eq(1)

      expect(page).to have_content('Contact created.')
      within(:css, "#contacts-table") do
        expect(page).to have_content(name)
        expect(page).to have_content(email)
        expect(page).to have_content(phone)
        expect(page).to have_content(organization)
      end

      within(:css, "#contacts-table") do
        find(:css, '.contact-delete').click
      end

      expect(Contact.count).to eq(0)

      expect(page).to have_content("Contact deleted.")
      expect(page).to_not have_content(name)
      expect(page).to_not have_content(email)
      expect(page).to_not have_content(phone)
      expect(page).to_not have_content(organization)
      expect(page).to_not have_content('Delete')
    end
  end
end
