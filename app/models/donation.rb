class Donation < ApplicationRecord
  validates_presence_of :amount, :donation_type, :date

  def self.check_donations
    where(donation_type: 'Check')
  end

  def self.stripe_donations
    where(donation_type: 'Credit')
  end

  def self.count_donors
    count
  end

  def self.calculate_funds
    pluck(:amount).sum(&:to_f)
  end

  def self.count_donors_checks
    check_donations.count
  end

  def self.count_donors_stripe
    stripe_donations.count
  end

  def self.calculate_funds_checks
    check_donations.calculate_funds
  end

  def self.calculate_funds_stripe
    stripe_donations.calculate_funds
  end
end