class DashboardController < ApplicationController

  def index
    unless params[:start_date] || params[:end_date]
      PaymentService.collect
    end
    @presenter = DashboardPresenter.new(date_params)
  end

  private

  def date_params
    params.permit(:start_date, :end_date)
  end
end