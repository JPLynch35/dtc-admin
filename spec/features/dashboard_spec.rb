require 'rails_helper'

describe 'an admin' do
  describe 'visiting the dashboard page' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before :each do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
    end

    it 'can see a list of credit donations' do
      customer = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'CO',
          address_city: 'Denver',
          address_line2: 'johnny214@gmail.com',
          )
      })
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: 2500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      visit dashboard_path
      expect(page).to have_content('Johnny App')
      expect(page).to have_content('Denver')
      expect(page).to have_content('CO')
      expect(page).to have_content('johnny214@gmail.com')
      expect(page).to have_content(2500)
      expect(page).to have_content('Credit')
    end

    it 'can see a list of check donations' do
      donation = create(:check_donation)

      visit dashboard_path

      expect(page).to have_content(donation.name)
      expect(page).to have_content(donation.city)
      expect(page).to have_content(donation.state)
      expect(page).to have_content(donation.email)
      expect(page).to have_content(donation.amount)
      expect(page).to have_content(donation.date)
    end

     it 'can filter donations by dates' do
      stripe_donation = create(:donation)
      check_donation = create(:check_donation, date: Time.now.tomorrow)

      visit dashboard_path

      fill_in "start_date", with: stripe_donation.date
      fill_in "end_date", with: stripe_donation.date
      click_button "Filter"
      
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content(stripe_donation.name)
      expect(page).to_not have_content(check_donation.name)
    end

    it 'can create a check donation and delete it' do
      expect(Donation.count).to eq(0)
      name = 'Bob'
      email = 'Bob@gmail.com'
      city = 'Denver'
      state = 'CO'
      amount = 500
      date = Date.today

      visit dashboard_path

      within(:css, "div#donate-form") do
        fill_in 'Date', with: date
        fill_in 'Name', with: name
        fill_in 'Email', with: email
        fill_in 'City', with: city
        fill_in 'State', with: state
        fill_in 'Amount', with: amount
      end

      click_on 'Create Donation'
      expect(current_path).to eq(dashboard_path)
      expect(Donation.count).to eq(1)
      expect(page).to have_content('Check Donations')
      expect(page).to have_content('Donation created.')
      expect(page).to have_content(name)
      expect(page).to have_content(city)
      expect(page).to have_content(state)
      expect(page).to have_content(amount)
      expect(page).to have_link('Delete')

      click_on 'Delete'
      expect(current_path).to eq(dashboard_path)
      expect(Donation.count).to eq(0)
      expect(page).to have_content('Check Donations')
      expect(page).to have_content("Donation deleted.")
      expect(page).to_not have_content(city)
      expect(page).to_not have_content(state)
      expect(page).to_not have_content(amount)
      expect(page).to_not have_content('Edit')
      expect(page).to_not have_content('Delete')
    end

   it 'can create a contact and delete a contact' do
      expect(Contact.count).to eq(0)
     
      name = 'Bob'
      email = 'Bob@gmail.com'
      phone = '345-654-3245'
      organization = 'organization'
      
      visit dashboard_path
      
      within(:css, "div#contact-form") do
        fill_in 'Name', with: name
        fill_in 'Email', with: email
        fill_in 'Phone', with: phone
        fill_in 'Organization', with: organization
      end

      click_on 'Create Contact'
      expect(current_path).to eq(dashboard_path)
      expect(Contact.count).to eq(1)
      expect(page).to have_content('Contacts')
      expect(page).to have_content('Contact created.')
      expect(page).to have_link('Delete')

      click_on 'Delete'
      expect(current_path).to eq(dashboard_path)
      expect(Contact.count).to eq(0)
      expect(page).to have_content('Contacts')
      expect(page).to have_content("Contact deleted.")
      expect(page).to_not have_content(email)
      expect(page).to_not have_content(phone)
      expect(page).to_not have_content('Delete')
    end
  end
end
