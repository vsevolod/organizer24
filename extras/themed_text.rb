# coding: utf-8

# Здравствуйте #{@appointment.firstname}. #{GENITIVE_WEEK_DAYS[@appointment.start.wday]} #{Russian.strftime( @appointment.start, "%d %B в %H:%M" )} Вы записаны к Золотаревой Анне на следующие услуги: #{@appointment.services.order(:name).pluck(:name).join(', ')}. Продолжительность приема: #{@appointment.showing_time.show_time}, Стоимость: #{@appointment.cost} руб. Адрес: ул. Алексеева 29-6
DEFAULT_USER_NOTIFY = <<-TEXT.freeze
  Здравствуйте <ИМЯ>! В <ДЕНЬ НЕДЕЛИ> <ДАТА НАЧАЛА> Вы записаны к мастеру <ДМАСТЕР> на следующие услуги: <СПИСОК УСЛУГ>. Продолжительность приема: <ПРОДОЛЖИТЕЛЬНОСТЬ>, стоимость: <СТОИМОСТЬ> руб. Адрес: ул.Алексеева 29-6 Телефон: <ТЕЛЕФОН МАСТЕРА> Сайт: depilate.ru
TEXT

# Функция шаблонизатор. Переделывает шаблоны по теме:
# 1) Название выбранной темы
# 2) Текст шаблона
# 3) Динамические параметры для шаблона

def themed_text(theme, text, options)
  case theme
  when :user_notify
    user_notify(text, options)
  end
end

def user_notify(text, appointment)
  text ||= DEFAULT_USER_NOTIFY
  { '<ИМЯ>' => appointment.firstname,
    '<ФАМИЛИЯ>' => appointment.lastname,
    '<ДЕНЬ НЕДЕЛИ>' => Organization::GENITIVE_WEEK_DAYS[appointment.start.wday],
    '<ДАТА НАЧАЛА>' => Russian.strftime(appointment.start, '%d %B в %H:%M'),
    '<СПИСОК УСЛУГ>' => appointment.services.order(:name).pluck(:name).join(', '),
    '<СТОИМОСТЬ>' => appointment.cost,
    '<МАСТЕР>' => appointment.worker.name,
    '<ДМАСТЕР>' => appointment.worker.dative_case,
    '<ПРОДОЛЖИТЕЛЬНОСТЬ>' => appointment.showing_time.show_time,
    '<ТЕЛЕФОН МАСТЕРА>' => appointment.worker.phone }.each_pair do |substring, value|
    text.gsub!(substring, value.to_s)
  end
  text
end
