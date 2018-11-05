class DashboardController < ApplicationController
before_action :authenticate_user!

  def index
    unless date_params[:start_date] || date_params[:end_date]
      PaymentService.collect
    end
    @presenter = DashboardPresenter.new(date_params)
  end

  private

  def date_params
    params.permit(:start_date, :end_date)
  end
end