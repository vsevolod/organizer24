class Integer
  def to_moment
    el = self
    result = []
    3.times do
      result.unshift('%02.f' % (el % 60))
      el /= 60
    end
    result * ':'
  end
end
