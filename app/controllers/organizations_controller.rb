# coding: utf-8
class OrganizationsController < ApplicationController
  layout 'company', :except => [:index]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @organization = (request.subdomain.blank?)? Organization.find(params[:id]) : Organization.find_by_subdomain(request.subdomain)
  end

  def calendar
    @organization = (request.subdomain.blank?)? Organization.find(params[:id]) : Organization.find_by_subdomain(request.subdomain)
  end

  def edit
    @activities = Dictionary.find_by_tag('activity').try(:children)
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if current_user.owner?( @organization)
      if @organization.update_attributes( params[:organization] )
        redirect_to @organization
      else
        render :edit
      end
    end
  end

end
