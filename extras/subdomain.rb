class Subdomain
  def self.matches?(request)
    name = request.server_name.gsub(/^www\./,'')
    if name !~ /^organizer24\./
      name
    end
    # REMOVE BEFORE PRODUCTION
    true
  end
end
