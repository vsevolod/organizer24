class Subdomain
  HOME_IP = ENV.fetch('HOME_IP', '1.1.1.1').freeze

  def self.matches?(request)
    return 'depilate' if Rails.env.development?
    name = request.subdomain
    name = request.domain || HOME_IP if name.blank? || name == 'www'
    name = name.gsub(/^www\./, '').split('.').first
    case name
    when 'oneclickbook', '1clickbook', HOME_IP.scan(/^\d+/).first
      false
    else
      name
    end
  end
end
