class DashboardPresenter
  def initialize(date_params)
    @start_date = date_params[:start_date]
    @end_date = date_params[:end_date]
  end

  def create_new_donation
    Donation.new
  end

  def create_new_contact
    Contact.new
  end

  def create_new_user
    User.new
  end

  def retrieve_stripe_donations
    Donation.stripe_donations.where(date: first_day_of_year..current_day).order(date: :desc)
  end

  def retrieve_check_donations
    Donation.check_donations.where(date: first_day_of_year..current_day)
  end

  def retrieve_all_donations
    Donation.all.where(date: first_day_of_year..current_day).order(date: :desc)
  end

  def retrieve_contacts
    Contact.all
  end

  def retrieve_users 
    User.where(admin: false)
  end

  def retrieve_stripe_subtotal
    retrieve_stripe_donations.pluck(:amount).sum(&:to_i) / 100.00
  end

  def retrieve_check_subtotal
    retrieve_check_donations.pluck(:amount).sum(&:to_i) / 100.00
  end

  def retrieve_all_total
    Donation.calculate_funds.to_i / 100
  end

  def retrieve_total_donors
    Donation.count_donors
  end

  def calculate_kids_sponsored
    (retrieve_all_total / 100).floor.to_i
  end

  private
  attr_reader :start_date, :end_date

  def first_day_of_year
    if start_date.nil? || start_date == ''
    "#{Date.today.year}" + "-01-01"
    else
      start_date
    end
  end

  def current_day
    if end_date.nil? || end_date == ''
      Time.now.strftime("%Y-%m-%d")
    else
      end_date
    end
  end
end