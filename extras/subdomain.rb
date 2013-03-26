class Subdomain
  def self.matches?(request)
    name = request.server_name.gsub(/^www\./,'')
    case name
    when /^organizer24\./
      false
    when '95.170.177.170'
      false
    else
      name
    end
  end
end
