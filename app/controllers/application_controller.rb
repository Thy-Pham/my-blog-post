class ApplicationController < ActionController::Base
    # Add this to not verify csrf token
    skip_before_action :verify_authenticity_token

    # Add exception handler missing parameter
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    private

    # If missing parameter => error code 400
    def parameter_missing(e)
        render json: { error: e.message }, status: :bad_request
    end
end
