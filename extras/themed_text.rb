#coding: utf-8

#Здравствуйте #{@appointment.firstname}. #{GENITIVE_WEEK_DAYS[@appointment.start.wday]} #{Russian.strftime( @appointment.start, "%d %B в %H:%M" )} Вы записаны к Золотаревой Анне на следующие услуги: #{@appointment.services.order(:name).pluck(:name).join(', ')}. Продолжительность приема: #{@appointment.showing_time.show_time}, Стоимость: #{@appointment.cost} руб. Адрес: ул. Алексеева 29-6

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
  { '<ИМЯ>' => appointment.firstname,
    '<ДЕНЬ НЕДЕЛИ>' => GENITIVE_WEEK_DAYS[appointment.start.wday],
    '<ДАТА НАЧАЛА>' => Russian.strftime( appointment.start, "%d %B в %H:%M" ),
    '<СПИСОК УСЛУГ>' => appointment.services.order(:name).pluck(:name).join(', '),
    '<СТОИМОСТЬ>' => appointment.cost,
    '<ПРОДОЛЖИТЕЛЬНОСТЬ>' => appointment.showing_time.show_time
  }.each_pair do |substring, value|
    text.gsub!(substring, value)
  end
  text
end
