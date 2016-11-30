class QueriesController < ApplicationController
  protect_from_forgery :except => [:create]
  before_action :set_current_user

  def new
  end

  def create
    query_string = params[:query]
    query_variables = ensure_hash(params[:variables])
    result = OrganizerSchema.execute(
      query_string,
      variables: query_variables,
      context: {
        current_user: set_current_user
      }
    )
    render json: result
  end

  private

    def ensure_hash(query_variables)
      if query_variables.blank?
        {}
      elsif query_variables.is_a?(String)
        JSON.parse(query_variables)
      else
        query_variables
      end
    end

    def set_current_user
      if verified_user = User.find_by(id: cookies.signed['user.id'])
        verified_user
      else
        nil
      end
    end

end
