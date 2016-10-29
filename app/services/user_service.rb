module UserService

  def prepare_phone(phone_number)
    phone_number = '+7' + phone_number.strip.sub(/^(7|8|\+7)/, '')
  end

end
