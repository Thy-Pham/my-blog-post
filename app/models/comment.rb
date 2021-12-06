class Comment < ApplicationRecord
  # validate status implemented in app/models/concerns/visible.rb
  include Visible

  belongs_to :article

  # Validate before save in db
  validates :commenter, presence: true
  validates :body, presence: true
end
