class Subdomain
  def self.matches?(request)
    name = request.subdomain
    if name.blank?
      name = request.domain
    end
    name = name.gsub(/^www\./,'').split('.').first
    case name
    when 'oneclickbook'
      false
    when '1clickbook'
      false
    when '95'
      false
    else
      name
    end
  end
end
