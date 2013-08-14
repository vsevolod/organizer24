# coding: utf-8
class AfterSignupController < ApplicationController
  include Wicked::Wizard
  steps :configurable_step, :add_dictionaries_step, :list_of_services_step, :first_owner_step

  # configurable_step:     set up primary configuration for organization
  # add_dictionaries_step: add dictionaries. f.e. categories list
  # list_of_services_step: create services for organization
  # first_owner_step:      create and set up first owner for organization
  # confirmable_step:      confirm all previous steps

  def show
    @user = current_user
    @organization = Organization.find(session[:organization_id])
    render_wizard
  end

  def update
    @user = current_user
    @organization = Organization.find(session[:organization_id])
    @organization.attributes = params[:organization]
    render_wizard @organization
  end


private

  def finish_wizard_path
    @organization = Organization.find(session[:organization_id])
    view_context.domain_organization_path(@organization)
  end

end
