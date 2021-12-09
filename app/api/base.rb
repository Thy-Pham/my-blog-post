class Base < Grape::API
    version 'v1', using: :path
    format :json

    helpers Pundit
    
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    before do
        if params[:authentication_token].present?
            @user = User.find_by_authentication_token(params[:authentication_token])
            @user
        end
    end

    helpers do
        def current_user
            @user
        end

        def user_not_authorized
            error!({ error: "Not authorized" }, 401)
        end
    end

    mount V1::Articles
end