class Subdomain
  def self.matches?(request)
    name = request.server_name.gsub(/^www\./,'')
    if name !~ /^organizer24\./ && Rails.env != 'development' || name != 'localhost'
      name
    end
  end
end
