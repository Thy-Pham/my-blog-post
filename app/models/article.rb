class Article < ApplicationRecord
    # validate status implemented in app/models/concerns/visible.rb
    include Visible

    # dependent: :destroy 
    # => can destroy articles and no need to destroy its comments in advance
    # Can destroy a article and this automacdestroy all its comments
    has_many :comments, dependent: :destroy

    # Validate before save in db
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }

end
