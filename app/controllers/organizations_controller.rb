# coding: utf-8
class OrganizationsController < ApplicationController

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def calendar
    @organization = Organization.find(params[:id])
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
