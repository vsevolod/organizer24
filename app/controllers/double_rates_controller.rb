class DoubleRatesController < CompanyController
  before_filter :prepare_calendar_options
  before_filter :find_worker

  respond_to :html, :json

  # TODO: remove this. Method is deprecated.
  def by_week
    double_rates = @worker.double_rates.where('date(day) >= :start AND date(day) <= :end OR week_day IS NOT NULL', {start: @start, end: @end})
    @period = []
    ((@start.to_date)..(@end.to_date)).each_with_index do |t, index|
      current_day = @start + index.days
      @period += double_rates.where('week_day = :week_day OR day = :current_day', {week_day: current_day.wday, current_day: current_day}).to_a.map do |double_rate|
        {:start => (current_day+double_rate.begin_time.to_i).iso8601, :end => (current_day+double_rate.end_time.to_i).iso8601, :editable => false, title: "Тариф: x#{double_rate.rate}", 'data-inner-class' => 'legend-rate'}
      end
    end
    respond_with(@period)
  end

end
