module UserService

  def prepare_phone(phone_number)
    phone_number = '+7' + phone_number.sub(/^8/, '').sub(/^\+7/, '')
  end

end
