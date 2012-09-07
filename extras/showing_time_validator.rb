# coding: utf-8
class ShowingTimeValidator < ActiveModel::EachValidator

  # Пересечение прямых: max( 0, max( A1, An ) - min( B1, Bn ) )
  # FIXME исправить для нескольких исполнителей
  # DESCRIPTION Валидация на продолжительность. Занято ли место или нет

  def validate_each( record, attribute, value )
    # передаётся хэш, где :start - дата начала, а :showing_time - продолжительность
    start = record.send( options[:start] )
    showing_time = record.send( options[:showing_time] )
    duplicate_record = record.class.where( <<-SQL, {:start => start.to_s(:db), :stop => (start+showing_time*60).to_s(:db)} )
      GREATEST( :start, "#{options[:start]}" ) > LEAST( :stop, "#{options[:start]}"+CONCAT(#{options[:showing_time]},' second')::interval )
    SQL
    unless duplicate_record.count.zero?
      record.errors[attribute] = "Данное время уже занято"
    end
  end

end
