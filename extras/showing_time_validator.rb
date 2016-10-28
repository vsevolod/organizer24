# coding: utf-8
class ShowingTimeValidator < ActiveModel::EachValidator
  # Пересечение прямых: max( 0, max( A1, An ) - min( B1, Bn ) )
  # FIXME исправить для нескольких исполнителей
  # TODO убрать динамические поля start и showing_time для appointment
  # DESCRIPTION Валидация на продолжительность. Занято место или нет

  def validate_each(record, _attribute, _value)
    # передаётся хэш, где :start - дата начала, а :showing_time - продолжительность
    start = record.send(options[:start])
    showing_time = record.send(options[:showing_time])
    duplicate_record = record.class.where(<<-SQL, start: start.utc.to_s, stop: (start + showing_time * 60).utc.to_s).where(:status => %w(offer approve taken), :organization_id => record.organization_id, :worker_id => record.worker_id).where.not(id: record.id)
      GREATEST( :start, "#{options[:start]}" ) < LEAST( :stop, "#{options[:start]}"+("#{options[:showing_time]}" || ' minute')::interval )
    SQL
    unless duplicate_record.count.zero?
      record.errors[:base] = "Продолжительность: #{showing_time.show_time}; Данное время уже занято"
    end
    # Проверка на запись только в рабочее время либо по двойному тарифу
    whs = record.worker.working_hours.where(week_day: start.wday) # Рабочее время
    drs = record.get_double_rates
    unless (whs + drs).map { |wh| [wh.begin_time, wh.end_time] }.union.inject(false) do |flag, range|
             flag || (range.first <= record.start_seconds && range.last >= record.end_seconds)
           end
      record.errors[:base] = 'В это время мастер не работает'
    end
  end
end
