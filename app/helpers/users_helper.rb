# coding: utf-8
module UsersHelper
  def full_user_name(user, joins = ' ')
    result = []
    result << "Email: #{user.email}"   if user.email
    result << "Телефон: #{user.phone}" if user.phone
    result << "Имя: #{user.name}"      if user.name
    result * joins
  end

  def owner_or_worker?
    @owner_or_worker ||= !current_user&.new_record? && current_user.owner_or_worker?(@organization)
  end
end
