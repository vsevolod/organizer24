module OrganizationsHelper
  require 'themed_text'

  def domain_organization_path( organization, add = '' )
    (organization.domain.blank? ? url_for(organization) : "http://#{organization.domain}.ru") + add
  end

  def pages
    @organization.pages.where.not(menu_name: nil)
  end
end
