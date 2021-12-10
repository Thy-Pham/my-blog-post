class ArticlePolicy < ApplicationPolicy
    def new?
      @user
    end

    def create?
      # @user
      client = EhProtobuf::EmploymentHero::Client.new
      response = client.check_admin({ email: @user.email })
      p "Response: #{response.result}"
      response.result.authorized
    end

    def update?
      # check current_user (@user) is matched with record that pundit is received (article)
      @user && @user.id == @record.user_id
    end

    def destroy?
      @user && @user.id == @record.user_id
    end
end
