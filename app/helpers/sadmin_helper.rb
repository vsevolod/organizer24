module SadminHelper
  def sadmin_get_id(organization)
    return "my_background_#{@organization.theme}" if show_organization_page?
    return 'skin-blur-ocean' if current_user && current_user.owner_or_worker?(@organization)

    "my_bg-#{@organization.theme}"
  end
end
