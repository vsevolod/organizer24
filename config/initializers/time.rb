class Time
  def iso8601utc
    iso8601.gsub(/\+.+/, '')
  end
end
