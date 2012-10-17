module SetLayout
  def company
    if defined? @organization
      if File.exist?( "app/views/layouts/#{@organization.theme}.html.haml" )
        @organization.theme
      else
        'company'
      end
    else
      'application'
    end
  end
end
