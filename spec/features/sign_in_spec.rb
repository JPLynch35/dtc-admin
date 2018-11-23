require 'rails_helper'

describe 'admin login workflow' do
  it 'allows registered admin to log in successfully' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin = true)

    visit '/'

    expect(page).to have_content('Sign In')
    expect(page).to have_link('Forgot your password?')

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on 'Sign In'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content('Sign Out')
    expect(page).to have_content('Change Password')
    expect(page).to have_content('Fill out the form to add a new check or cash donation.')
    expect(page).to_not have_content('Sign In')

    click_on 'Sign Out'
    expect(current_path).to eq('/')
  end
end