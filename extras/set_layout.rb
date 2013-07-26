module SetLayout
  def company
    if defined? @organization
      if File.exist?( "#{Rails.root}/app/views/layouts/#{@organization.theme}.html.haml" )
        @organization.theme
      else
        'company'
      end
    else
      'application'
    end
  end
end
