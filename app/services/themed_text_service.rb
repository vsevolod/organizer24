module ThemedTextService
  module_function

  def user_notify(appointment)
    template = appointment.worker.user_notify_template || <<-TEXT
      Здравствуйте <ИМЯ>!
      В <ДЕНЬ НЕДЕЛИ> <ДАТА НАЧАЛА> Вы записаны к мастеру <ДМАСТЕР> на следующие услуги: <СПИСОК УСЛУГ>.
      Продолжительность приема: <ПРОДОЛЖИТЕЛЬНОСТЬ>, стоимость: <СТОИМОСТЬ> руб.
      Телефон: <ТЕЛЕФОН МАСТЕРА>
    TEXT

    {
      'ИМЯ'               => appointment.firstname,
      'ФАМИЛИЯ'           => appointment.lastname,
      'ДЕНЬ НЕДЕЛИ'       => Organization::GENITIVE_WEEK_DAYS[appointment.start.wday],
      'ДАТА НАЧАЛА'       => Russian.strftime(appointment.start, '%d %B в %H:%M'),
      'СПИСОК УСЛУГ'      => appointment.services.order(:name).pluck(:name).join(', '),
      'СТОИМОСТЬ'         => appointment.cost,
      'МАСТЕР'            => appointment.worker.name,
      'ДМАСТЕР'           => appointment.worker.dative_case,
      'ПРОДОЛЖИТЕЛЬНОСТЬ' => appointment.showing_time.show_time,
      'ТЕЛЕФОН МАСТЕРА'   => appointment.worker.phone
    }.inject(template) do |result, (substring, value)|
      result.gsub!("<#{substring}>", value.to_s) || result
    end
  end
end
