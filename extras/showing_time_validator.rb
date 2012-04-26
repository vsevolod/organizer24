# coding: utf-8
class ShowingTimeValidator < ActiveModel::EachValidator

  # Пересечение прямых: max( 0, max( A1, An ) - min( B1, Bn ) )
  # FIXME исправить для нескольких исполнителей
  # DESCRIPTION Валидация на продолжительность. Занято ли место или нет

  def validate_each( record, attribute, value )
    # передаётся хэш, где :start - дата начала, а :showing_time - продолжительность
    start = record.send( options[:width][:start] )
    showing_time = record.send( options[:width][:showing_time] )
    duplicate_record = record.class.limit(1).where( <<-SQL, {:start => start, :stop => start+showing_time} )
      max( :start, #{options[:width][:start]}  ) > min( :stop, #{options[:width][:start]}+#{options[:width][:showing_time]}
    SQL
    unless duplicate_record.count.zero?
      record.errors[attribute] = "Данное время уже занято для этой организации"
    end
  end

end
