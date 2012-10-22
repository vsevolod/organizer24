class SessionsController < Devise::SessionsController
  include SetLayout
  before_filter :find_organization
  layout :company

end
