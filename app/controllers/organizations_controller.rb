# coding: utf-8
class OrganizationsController < ApplicationController
  layout 'company', :except => [:index]
  before_filter :find_organization, :only => [:show, :calendar, :edit, :update]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @category_photos = @organization.category_photos.joins(:photos).uniq
    @services = @organization.services.not_collections
  end

  def calendar
  end

  def edit
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def update
    if current_user.owner?( @organization)
      if @organization.update_attributes( params[:organization] )
        redirect_to organization_root
      else
        render :edit
      end
    end
  end

end
