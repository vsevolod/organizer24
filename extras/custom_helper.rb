# coding: utf-8
module CustomHelper

  MINUTE_LEVEL = [ %w{минута минуты минут},
                   %w{час часа часов},
                   %w{день дня дней} ]

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
