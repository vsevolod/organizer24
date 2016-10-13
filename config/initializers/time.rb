class Time

  def iso8601utc
    self.iso8601.gsub(/\+.+/,'')
  end

end
