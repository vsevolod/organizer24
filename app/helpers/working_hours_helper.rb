module WorkingHoursHelper

  def human_time( time_in_integer )
    "#{"%02i" % (time_in_integer/60/60)}:#{"%02i" % (time_in_integer/60%60)}"
  end

end
