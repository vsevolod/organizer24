# coding: utf-8
module ApplicationHelper

  def week_days_for_select
    week_days = t('date.standalone_day_names').dup.inject([]){|arr, wd| arr.push( [wd, arr.size.to_s] )}
    week_days.push(week_days.shift)
  end

  def appointment_links( appointment, joins = '<br/>' )
    org = appointment.organization
    arr = []
    if current_user.owner?( org )
      { :complete => 'btn-success', :cancel_owner => '', :cancel_client => 'btn-warning', :missing => 'btn-danger', :lated => 'btn-info'}.each do |state, html_class|
        arr << link_to( t("activerecord.attributes.appointment.status.#{state}"), short_csoap(org, appointment, state ), :class => "btn #{html_class}", :method => :post ) if appointment.aasm_read_state != state
     end
    elsif current_user == appointment.user && !appointment.cancel_client?
      arr << link_to( 'Отменить', short_csoap(org, appointment, :cancel_client ), :class => 'btn btn-danger', :method => :post )
    end
    arr.join(joins).html_safe
  end

  def show_errors( object )
    render 'layouts/errors', :object => object
  end

  def get_class
    klass = []
    klass << "#{params[:controller]}_#{params[:action]}".gsub('/','_')
    klass << "user_signed" if current_user
    klass.join(' ')
  end

  private

    def short_csoap( org, appointment, state)
      change_status_appointment_path(appointment, :state => state)
    end

end
