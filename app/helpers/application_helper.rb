# coding: utf-8
module ApplicationHelper
  MINUTE_LEVEL = [ %w{минута минуты минут},
                   %w{час часа часов},
                   %w{день дня дней} ]

  def week_days_for_select
    week_days = t('date.standalone_day_names').dup.inject([]){|arr, wd| arr.push( [wd, arr.size.to_s] )}
    week_days.push(week_days.shift)
  end

  def show_time( interval, level = 0 )
    if interval.zero?
      ''
    else
      divisor = case level
                when 0 then 60
                when 1 then 24
                when 2 then 30
                end
      result = show_time( interval / divisor, level + 1)
      result += " #{interval % divisor} #{Russian.p( interval % divisor, *MINUTE_LEVEL[level] )}"unless (interval % divisor ).zero?
      result
    end
  end

  def appointment_links( appointment, joins = '<br/>' )
    org = appointment.organization
    arr = []
    if current_user.owner?( org )
      arr << link_to( 'Заявка выполнена', short_csoap(org, appointment, :complete ), :class => 'btn btn-success', :method => :post )
      arr << link_to( 'Отменена владельцем',  short_csoap(org, appointment, :cancel_owner ), :class => 'btn', :method => :post )
      arr << link_to( 'Отменена клиентом',   short_csoap(org, appointment, :cancel_client ), :class => 'btn btn-warning', :method => :post )
      arr << link_to( 'Клиент не пришёл', short_csoap(org, appointment, :missing ), :class => 'btn btn-danger', :method => :post )
      arr << link_to( 'Клиент опоздал',   short_csoap(org, appointment, :lated ), :class => 'btn btn-info', :method => :post )
    elsif current_user == appointment.user
      arr << link_to( 'Отменить', short_csoap(org, appointment, :cancel_client ), :class => 'btn btn-danger', :method => :post )
    end
    arr.join(joins).html_safe
  end

  private

    def short_csoap( org, appointment, state)
      change_status_organization_appointment_path(org, appointment, :state => state)
    end

end
