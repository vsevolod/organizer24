class Subdomain
  def self.matches?(request)
    name = request.server_name.gsub(/^www\./,'')
    if name !~ /^organizer24\./
      name
    end
  end
end
