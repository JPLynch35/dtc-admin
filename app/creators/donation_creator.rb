class DonationCreator

  def initialize(payment)
    unless Donation.find_by_stripe_id(payment[:id])
      Donation.create(
        stripe_id:      payment[:id], 
        name:           payment[:source][:name].capitalize, 
        amount:         payment[:amount],
        donation_type: 'Credit',
        city:           payment[:source][:address_city], 
        state:          payment[:source][:address_state],
        email:          payment[:source][:address_line2],
        date:           format_date(payment[:created])
      )
    end
  end

private

  def format_date(raw_date)
    Time.at(raw_date).to_date
  end
end