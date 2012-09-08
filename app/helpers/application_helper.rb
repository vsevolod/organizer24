# coding: utf-8
module ApplicationHelper
  MINUTE_LEVEL = [ %w{минута минуты минут},
                   %w{час часа часов},
                   %w{день дня дней} ]

  def week_days_for_select
    week_days = t('date.standalone_day_names').dup.inject([]){|arr, wd| arr.push( [wd, arr.size.to_s] )}
    week_days.push(week_days.shift)
  end

  def show_time( interval, level = 0 )
    if interval.zero?
      ''
    else
      divisor = case level
                when 0 then 60
                when 1 then 24
                when 2 then 30
                end
      result = show_time( interval / divisor, level + 1)
      result += " #{interval % divisor} #{Russian.p( interval % divisor, *MINUTE_LEVEL[level] )}"unless (interval % divisor ).zero?
      result
    end
  end

end
