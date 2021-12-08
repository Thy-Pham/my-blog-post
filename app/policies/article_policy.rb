class ArticlePolicy < ApplicationPolicy
    def new?
      @user
    end

    def create?
      @user
    end

    def update?
      # check current_user (@user) is matched with record that pundit is received (article)
      @user && @user.id == @record.user_id
    end

    def destroy?
      @user && @user.id == @record.user_id
    end
end
