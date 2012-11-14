class PasswordsController < Devise::PasswordsController
  include SetLayout
  before_filter :find_organization
  layout :company

end
