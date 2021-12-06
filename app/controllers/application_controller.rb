class ApplicationController < ActionController::Base
    # Add this to not verify csrf token
    skip_before_action :verify_authenticity_token
end
