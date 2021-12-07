class ChangeUsersIdToUserIdInArticles < ActiveRecord::Migration[6.1]
  def change
    rename_column :articles, :users_id, :user_id
  end
end
