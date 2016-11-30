module SetLayout
  def company
    if defined? @organization
      # TODO move it to cache
      if File.exist?( "#{Rails.root}/app/views/layouts/#{@organization.get_theme}.html.haml" )
        @organization.get_theme
      else
        'company'
      end
    else
      'application'
    end
  end
end
