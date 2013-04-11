# coding: utf-8
class ShowingTimeValidator < ActiveModel::EachValidator

  # Пересечение прямых: max( 0, max( A1, An ) - min( B1, Bn ) )
  # FIXME исправить для нескольких исполнителей
  # DESCRIPTION Валидация на продолжительность. Занято место или нет

  def validate_each( record, attribute, value )
    # передаётся хэш, где :start - дата начала, а :showing_time - продолжительность
    start = record.send( options[:start] )
    showing_time = record.send( options[:showing_time] )
    duplicate_record = record.class.where( <<-SQL, {:start => start.utc.to_s, :stop => (start+showing_time*60).utc.to_s} ).where( :status => ['offer', 'approve', 'taken'], :id.not_eq => record.id, :organization_id => record.organization_id )
      GREATEST( :start, "#{options[:start]}" ) < LEAST( :stop, "#{options[:start]}"+("#{options[:showing_time]}" || ' second')::interval )
    SQL
    unless duplicate_record.count.zero?
      record.errors[:base] = "Продолжительность: #{showing_time.show_time}; Данное время уже занято"
    end
  end

end
