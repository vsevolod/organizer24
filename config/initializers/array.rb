class Array
  
  # Вычитает из одного массива рейнджев другой массив рейнджев
  def exclude!(other_array)
    self.dup.each_with_index do |self_range, index|
      other_array.each do |other_range|
        begin_included = self_range.first <= other_range.first && self_range.last >  other_range.first
        end_included   = self_range.first <  other_range.last  && self_range.last >= other_range.last
        if begin_included
          self.push([other_range.last, self_range.last]) if end_included
          self[index][1] = other_range.first
        elsif end_included
          self[index][0] = other_range.last
        end
        if self_range.first > other_range.first && self_range.last < other_range.last
          self[index] = nil
        end
      end
    end
    self.compact
  end

  # Объединяет рейнджи в массиве
  def union
    result = self.dup
    result.each_with_index do |i, i_index|
      result[i_index+1..-1].each_with_index do |j, j_index|
        if [i.first, j.first].max <= [i.last, j.last].min
          result[i_index] = [[i.first, j.first].min, [i.last, j.last].max]
          result.delete_at(j_index+i_index+1)
        end
      end
    end
    result == self ? result : result.union
  end

end
