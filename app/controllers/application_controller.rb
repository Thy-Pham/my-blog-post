class ApplicationController < ActionController::Base
    # Add this
    include Pundit
    acts_as_token_authentication_handler_for User, except: [:index, :show]

    # Add this to not verify csrf token
    skip_before_action :verify_authenticity_token

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Add exception handler missing parameter
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    private

    # If missing parameter => error code 400
    def parameter_missing(e)
        render json: { error: e.message }, status: :bad_request
    end

    def user_not_authorized
        render json: { error: "Not authorized" }, status: :unauthorized
    end
end
