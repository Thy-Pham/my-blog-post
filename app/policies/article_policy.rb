class ArticlePolicy < ApplicationPolicy
    def new?
      @user
    end

    def create?
      @user
      # true
    end

    def update?
      @user && @user.id == @record.user_id
    end

    def destroy?
      @user && @user.id == @record.user_id
    end
end
