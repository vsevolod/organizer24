module SadminHelper

  def sadmin_get_id(organization)
    if show_organization_page?
      "my_background_#{@organization.theme}"
    else
      if false && current_user && current_user.owner_or_worker?(@organization)
        'skin-blur-ocean'
      else
        "my_bg-#{@organization.theme}"
      end
    end
  end

end
