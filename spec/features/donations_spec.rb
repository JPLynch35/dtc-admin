require 'rails_helper'

describe 'an admin' do
  describe 'visiting the donations tab' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before :each do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'can see a list of credit card donations from stripe' do
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
      expect(page).to have_content('Johnny app')
      expect(page).to have_content('Denver')
      expect(page).to have_content('CO')
      expect(page).to have_content('johnny214@gmail.com')
      expect(page).to have_content('$25.00')
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
      click_button "Filter Donations"

      # expect(current_path).to eq(dashboard_path)
      # expect(page).to have_content(stripe_donation.name)
      # expect(page).to_not have_content(check_donation.name)
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
        fill_in "donation[date]", with: date
        fill_in "donation[name]", with: name
        fill_in "donation[email]", with: email
        fill_in "donation[city]", with: city
        fill_in "donation[state]", with: state
        fill_in "donation[amount]", with: amount
      end

      click_on 'Add Donation'
      expect(Donation.count).to eq(1)
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Donation from #{name} has been added.")
      expect(page).to have_content(name)
      expect(page).to have_content(city)
      expect(page).to have_content(state)
      expect(page).to have_content(amount)
      expect(page).to have_css('.far')

      within(:css, "#donations-table") do
        find(:css, '.donation-delete').click
      end

      expect(current_path).to eq(dashboard_path)
      expect(Donation.count).to eq(0)
      expect(page).to have_content("Donation from #{name} has been deleted.")
      expect(page).to_not have_content(city)
      expect(page).to_not have_content(state)
      expect(page).to_not have_content(amount)
    end

    it 'will not create a donation if missing required information' do
      expect(Donation.count).to eq(0)
      name = 'Bob'
      email = 'Bob@gmail.com'
      city = 'Denver'
      state = 'CO'
      date = Date.today

      visit dashboard_path

      within(:css, "div#donate-form") do
        fill_in "donation[date]", with: date
        fill_in "donation[name]", with: name
        fill_in "donation[email]", with: email
        fill_in "donation[city]", with: city
        fill_in "donation[state]", with: state
      end

      click_on 'Add Donation'

      expect(page).to have_content('Donation was not created.')
      expect(Donation.count).to eq(0)
    end

    it 'can see subtotals for credit and check donations' do
      customer1 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'CO',
          address_city: 'Denver',
          address_line2: 'johnny214@gmail.com',
          )
      })
      customer2 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'PA',
          address_city: 'Hampton',
          address_line2: 'Tonya213@gmail.com',
          )
      })
      customer3 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'NJ',
          address_city: 'Ewing',
          address_line2: 'TankTheTank23@gmail.com',
          )
      })
      charge1 = Stripe::Charge.create({
        customer: customer1.id,
        amount: 2500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge2 = Stripe::Charge.create({
        customer: customer2.id,
        amount: 1500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge3 = Stripe::Charge.create({
        customer: customer3.id,
        amount: 570,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      check_donation = Donation.create(
        name: 'Tanya Toni',
        email: 'TonyaTheTiger122@gmail.com',
        amount: '675',
        donation_type: 'Check',
        city: 'Denver',
        state: 'CO',
        date: Date.today
      )
      
      visit dashboard_path

      # expect(page).to have_content('Sub-Total: $45.70')
      # expect(page).to have_content('Sub-Total: $6.75')
    end

    it 'can see total for all donations ever made' do
      customer1 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'CO',
          address_city: 'Denver',
          address_line2: 'johnny214@gmail.com',
          )
      })
      customer2 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'PA',
          address_city: 'Hampton',
          address_line2: 'Tonya213@gmail.com',
          )
      })
      customer3 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'NJ',
          address_city: 'Ewing',
          address_line2: 'TankTheTank23@gmail.com',
          )
      })
      charge1 = Stripe::Charge.create({
        customer: customer1.id,
        amount: 2500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge2 = Stripe::Charge.create({
        customer: customer2.id,
        amount: 1500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge3 = Stripe::Charge.create({
        customer: customer3.id,
        amount: 570,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      check_donation = Donation.create(
        name: 'Tanya Toni',
        email: 'TonyaTheTiger122@gmail.com',
        amount: '675',
        donation_type: 'Check',
        city: 'Denver',
        state: 'CO',
        date: Date.today
      )
      
      visit dashboard_path
      within('.donations-circle') do
        expect(page).to have_content('$52')
      end
    end

    it 'can see total number of donors' do
      customer1 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'CO',
          address_city: 'Denver',
          address_line2: 'johnny214@gmail.com',
          )
      })
      customer2 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'PA',
          address_city: 'Hampton',
          address_line2: 'Tonya213@gmail.com',
          )
      })
      customer3 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'NJ',
          address_city: 'Ewing',
          address_line2: 'TankTheTank23@gmail.com',
          )
      })
      charge1 = Stripe::Charge.create({
        customer: customer1.id,
        amount: 2500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge2 = Stripe::Charge.create({
        customer: customer2.id,
        amount: 1500,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge3 = Stripe::Charge.create({
        customer: customer3.id,
        amount: 570,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      check_donation = Donation.create(
        name: 'Tanya Toni',
        email: 'TonyaTheTiger122@gmail.com',
        amount: '675',
        donation_type: 'Check',
        city: 'Denver',
        state: 'CO',
        date: Date.today
      )
      
      visit dashboard_path
      within('.donors-circle') do
        expect(page).to have_content('4')
      end
    end

    it 'can see total number kids sponsored' do
      customer1 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'CO',
          address_city: 'Denver',
          address_line2: 'johnny214@gmail.com',
          )
      })
      customer2 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'PA',
          address_city: 'Hampton',
          address_line2: 'Tonya213@gmail.com',
          )
      })
      customer3 = Stripe::Customer.create({
        source: stripe_helper.generate_card_token(
          address_state: 'NJ',
          address_city: 'Ewing',
          address_line2: 'TankTheTank23@gmail.com',
          )
      })
      charge1 = Stripe::Charge.create({
        customer: customer1.id,
        amount: 250000,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge2 = Stripe::Charge.create({
        customer: customer2.id,
        amount: 150000,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      charge3 = Stripe::Charge.create({
        customer: customer3.id,
        amount: 57000,
        currency: 'usd',
        created: Date.today.to_time.to_i
      })
      check_donation = Donation.create(
        name: 'Tanya Toni',
        email: 'TonyaTheTiger122@gmail.com',
        amount: '67500',
        donation_type: 'Check',
        city: 'Denver',
        state: 'CO',
        date: Date.today
      )
      
      visit dashboard_path
      within('.kids-circle') do
        expect(page).to have_content('52')
      end
    end
  end
end
