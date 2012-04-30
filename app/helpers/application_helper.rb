module ApplicationHelper

  def week_days_for_select
    week_days = t('date.standalone_day_names').dup.inject([]){|arr, wd| arr.push( [wd, arr.size.to_s] )}
    week_days.push(week_days.shift)
  end

end
