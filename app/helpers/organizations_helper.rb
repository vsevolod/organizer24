module OrganizationsHelper

  def domain_organization_path( organization )
    organization.subdomain.blank? ? url_for( organization ) : "http://#{organization.subdomain}.organizer24.ru"
  end

end
