class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def find_organization
      @organization = (request.subdomain.blank?)? Organization.find(params[:organization_id]) : Organization.find_by_subdomain(request.subdomain)
    end

    def redirect_if_not_owner
      if !current_user || !current_user.owner?( @organization )
        redirect_to @organization
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
