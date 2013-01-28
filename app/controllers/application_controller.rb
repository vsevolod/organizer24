class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def find_organization
      if name = Subdomain.matches?(request)
        @organization = Organization.find_by_domain(name) || Organization.find_by_domain(request.subdomain)
      elsif params[:organization_id]
        @organization = Organization.find(params[:organization_id])
      end
    end

    def organization_root
      if Subdomain.matches?(request)
        root_path
      else
        @organization || root_path
      end
    end

    def redirect_if_not_owner
      if !current_user || !current_user.owner?( @organization )
        redirect_to organization_root
      end
    end

    def ancestry_options(items)
      result = []
      items.map do |item, sub_items|
        result << [yield(item), item.id]
        #this is a recursive call:
        result += ancestry_options(sub_items) {|i| "#{'-' * i.depth} #{i.name}" } if sub_items
      end
      result
    end

end
