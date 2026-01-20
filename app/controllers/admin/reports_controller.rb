class Admin::ReportsController < ApplicationController
  before_action :authenticate_user!

  def daily_dispute_volume
    authorize :report, :view?
    @from = params[:from].presence
    @to   = params[:to].presence

    @rows = Reports::DailyDisputeVolume.call(
      from: @from,
      to: @to,
      time_zone: current_user.time_zone
    )

    respond_to do |format|
      format.html
      format.json { render json: @rows }
    end
  end

  def time_to_decision
    authorize :report, :view?

    @rows = Reports::TimeToDecision.call(time_zone: current_user.time_zone)

    respond_to do |format|
      format.html
      format.json { render json: @rows }
    end
  end
end
