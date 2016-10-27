class Subdomain
  HOME_IP = '89.105.156.230'.freeze

  def self.matches?(request)
    return 'depilate' if Rails.env.development?
    name = request.subdomain
    name = request.domain || HOME_IP if name.blank? || name == 'www'
    name = name.gsub(/^www\./, '').split('.').first
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
