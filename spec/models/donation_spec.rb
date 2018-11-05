require 'rails_helper'

RSpec.describe Donation, type: :model do
  describe "attributes" do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:donation_type) }
    it { should validate_presence_of(:date) }
    it { should_not validate_presence_of(:stripe_id) }
    it { should_not validate_presence_of(:name) }
    it { should_not validate_presence_of(:email) }
    it { should_not validate_presence_of(:city) }
    it { should_not validate_presence_of(:state) }
  end

  describe "class methods" do
    it "can count donations, stripe and checks " do
      create_list(:donation, 5)
      create_list(:check_donation, 4)

      expect(Donation.count_donors).to eq(9)
      expect(Donation.count_donors_checks).to eq(4)
      expect(Donation.count_donors_stripe).to eq(5)
    end

    it "can calculate amounts donated, stripe and checks " do
      create_list(:donation, 5)
      create_list(:check_donation, 4)

      expect(Donation.calculate_funds).to eq(225)
      expect(Donation.calculate_funds_checks).to eq(100)
      expect(Donation.calculate_funds_stripe).to eq(125)
    end
  end
end