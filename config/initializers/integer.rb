# coding: utf-8
class Integer

  MINUTE_LEVEL = [ %w{минута минуты минут},
                   %w{час часа часов},
                   %w{день дня дней} ]

  def show_time( level = 0 )
    interval = self
    if interval.zero?
      ''
    else
      divisor = case level
                when 0 then 60
                when 1 then 24
                when 2 then 30
                end
      result = (interval / divisor).show_time(level + 1)
      result += " #{interval % divisor} #{Russian.p( interval % divisor, *MINUTE_LEVEL[level] )}"unless (interval % divisor ).zero?
      result
    end
  end


end
