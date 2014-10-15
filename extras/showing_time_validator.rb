# coding: utf-8
class ShowingTimeValidator < ActiveModel::EachValidator

  # Пересечение прямых: max( 0, max( A1, An ) - min( B1, Bn ) )
  # FIXME исправить для нескольких исполнителей
  # DESCRIPTION Валидация на продолжительность. Занято место или нет

  def validate_each( record, attribute, value )
    # передаётся хэш, где :start - дата начала, а :showing_time - продолжительность
    start = record.send( options[:start] )
    showing_time = record.send( options[:showing_time] )
    duplicate_record = record.class.where( <<-SQL, {:start => start.utc.to_s, :stop => (start+showing_time*60).utc.to_s} ).where( :status => ['offer', 'approve', 'taken'], :id.not_eq => record.id, :organization_id => record.organization_id, :worker_id => record.worker_id )
      GREATEST( :start, "#{options[:start]}" ) < LEAST( :stop, "#{options[:start]}"+("#{options[:showing_time]}" || ' minute')::interval )
    SQL
    unless duplicate_record.count.zero?
      record.errors[:base] = "Продолжительность: #{showing_time.show_time}; Данное время уже занято"
    end
    # Проверка на запись только в рабочее время либо по двойному тарифу
    whs = record.worker.working_hours.where(week_day: start.wday) # Рабочее время
    drs = record.worker.double_rates.where('week_day = :week_day OR day = :current_day', {week_day: start.wday, current_day: start.to_date}) # Время двойных тарифов
    start_s = start - start.at_beginning_of_day # начало записи в секундах
    end_s = start_s + showing_time*60           # конец  записи в секундах
    unless (whs + drs).map{|wh| [wh.begin_time, wh.end_time]}.union.inject(false) do |flag, range|
        flag || (range.first <= start_s && range.last >= end_s)
      end
      record.errors[:base] = "В это время мастер не работает"
    end
  end

end
