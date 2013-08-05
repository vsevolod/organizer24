class Subdomain

  HOME_IP = '89.105.156.230'

  def self.matches?(request)
    name = request.subdomain
    if name.blank? || name == 'www'
      name = request.domain || HOME_IP
    end
    name = name.gsub(/^www\./,'').split('.').first
    case name
    when 'oneclickbook'
      false
    when '1clickbook'
      false
    when HOME_IP.scan(/^\d+/).first
      false
    else
      name
    end
  end
end
