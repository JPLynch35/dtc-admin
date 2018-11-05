class DonationCreator

  def initialize(payment)
    Donation.create!(
      stripe_id: payment[:id], 
      name: payment[:source][:name], 
      amount: payment[:amount],
      donation_type: 'Credit',
      city: payment[:source][:address_city], 
      state: payment[:source][:address_state],
      email: payment[:source][:address_line2],
      date: format_date(payment[:created])
    )
  end

private

  def format_date(raw_date)
    Time.at(raw_date).to_date
  end
end