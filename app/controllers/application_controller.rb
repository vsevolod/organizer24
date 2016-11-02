class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def find_organization
    if name = Subdomain.matches?(request)
      @organization = Organization.find_by(domain: name) || Organization.find_by(domain: request.subdomain)
    elsif params[:organization_id]
      @organization = Organization.find(params[:organization_id])
    end
    # raise ActiveRecord::RecordNotFound unless @organization
  end

  def organization_root
    if Subdomain.matches?(request)
      root_path
    else
      @organization || root_path
    end
  end

  def redirect_if_not_owner
    if !current_user || !current_user.owner_or_worker?(@organization)
      redirect_to organization_root
    end
  end

  def ancestry_options(items)
    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id]
      # this is a recursive call:
      result += ancestry_options(sub_items) { |i| "#{'-' * i.depth} #{i.name}" } if sub_items
    end
    result
  end

  def check_iframe
    if request.env['HTTP_REFERER'] && !(['oneclickbook.ru', '1clickbook.ru', '95.170.177.170', 'organizer24.com'].inject(false) { |res, domain| (Regexp.new("//[^/]+#{domain}") =~ request.env['HTTP_REFERER']) || res })
      @iframe = true
    end
  end

  def need_to_login
    redirect_to '/' unless current_user
  end
end
