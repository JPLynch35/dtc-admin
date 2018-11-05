
class DonationRepository
 
  def initialize(raw_payments)
    @raw_payments = raw_payments
  end

  def run
    @raw_payments.each do |payment|
       DonationCreator.new(payment)
    end
  end
end