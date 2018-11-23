require 'rails_helper'

describe 'a user' do
  describe 'visiting the users tab' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before :each do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
      user1 = create(:user, admin:'false')
      @user2 = create(:user, email: 'Bob435@gmail.com', admin:'false')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
    end

    it 'cannot see, create or delete users' do
      visit dashboard_path

      expect(page).to_not have_content(@user2.email)
    end
  end
end

describe 'an admin' do
  describe 'visiting the users tab' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before :each do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'can create and delete a user account' do
      expect(User.count).to eq(1)
      
      email = 'bob1414@gmail.com'
      password = 'password-test'
    
      visit dashboard_path
      within(:css, "div#user-form") do
        fill_in 'user-email', with: email
        fill_in 'user-password', with: password
      end

      click_on 'Add User'

      expect(User.count).to eq(2)
      expect(page).to have_content("#{email} now has access to the Dress The Child donations dashboard.")
      expect(page).to have_content(email)

      within(:css, "#users-table") do
        find(:css, '.user-delete').click
      end

      expect(User.count).to eq(1)
      expect(page).to have_content("#{email} no longer has access to the Dress The Child donations dashboard.")
    end

    it 'will not create a user if the email is invalid' do
      expect(User.count).to eq(1)
      
      email = 'bob1616'
      password = 'password-test'
    
      visit dashboard_path
      within(:css, "div#user-form") do
        fill_in 'user-email', with: email
        fill_in 'user-password', with: password
      end

      click_on 'Add User'

      expect(page).to have_content('User was not created.')
      expect(User.count).to eq(1)
      expect(page).to_not have_content(email)
    end

    it 'will not create a user if the password is invalid' do
      expect(User.count).to eq(1)
      
      email = 'bob1616@gmail.com'
      password = 'pass'
    
      visit dashboard_path
      within(:css, "div#user-form") do
        fill_in 'user-email', with: email
        fill_in 'user-password', with: password
      end

      click_on 'Add User'

      expect(page).to have_content('User was not created.')
      expect(User.count).to eq(1)
      expect(page).to_not have_content(email)
    end
  end
end
