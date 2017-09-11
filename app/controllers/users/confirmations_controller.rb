module Users
  class ConfirmationsController < Devise::ConfirmationsController
    include SetLayout
    before_action :find_organization
    layout :company

    def new
      super
    end

    def create
      raise 'A2'
      super
    end

    def confirm_phone
      @user = User.find(params[:id])
      redirect_to '/' if @user.confirmed?
    end

    def confirming_phone
      @user = User.find(params[:id])
      if @user.confirmed?
        redirect_to '/'
      else
        if @user.confirmation_number == params[:confirmation_number]
          @user.confirm!
        else
          redirect_to [:confirm_phone, @user], alert: 'Введен неверный код подтверждения'
        end
      end
    end
  end
end
