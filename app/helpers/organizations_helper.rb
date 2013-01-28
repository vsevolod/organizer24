module OrganizationsHelper

  def domain_organization_path( organization, add = '' )
    (organization.domain.blank? ? url_for( organization ) : "http://#{organization.domain}") + add
  end

end
