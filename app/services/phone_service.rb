module PhoneService
  class NotValidPhone < StandardError; end
  extend self

  def parse(phone)
    return nil unless phone.present?

    new_phone =
        case phone
        when /^7/
          phone.gsub(/^7/, '+7')
        when /^8/
          phone.gsub(/^8/, '+7')
        when /^9/
          '+7' + phone
        when /^\+7/
          phone
        else
          raise NotValidPhone, 'Not valid phone number'
        end
    new_phone.gsub!(/( |-|\(|\))/, '')

    return new_phone if new_phone.size == 12

    raise NotValidPhone, 'Not valid phone number'
  end
end
