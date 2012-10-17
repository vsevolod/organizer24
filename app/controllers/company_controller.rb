class CompanyController < ApplicationController
  include SetLayout
  before_filter :find_organization
  layout :company

end
