class Subdomain
  def self.matches?(request)
    # REMOVE BEFORE PRODUCTION
    true
    # case request.subdomain
    # when 'www', '', nil
    #   false
    # else
    #   true
    # end
  end
end
