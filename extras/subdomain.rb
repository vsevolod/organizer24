class Subdomain
  def self.matches?(request)
    name = request.server_name.gsub(/^www\./,'').split('.').first
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
