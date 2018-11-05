class PaymentService 

  def self.collect
    raw_payments = Stripe::Charge.all.data
    DonationRepository.new(raw_payments).run
  end
end