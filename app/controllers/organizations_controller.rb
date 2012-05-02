class OrganizationsController < ApplicationController

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def edit
    @activities = Dictionary.find_by_tag('activity').try(:children)
    @organization = Organization.find(params[:id])
  end

end
