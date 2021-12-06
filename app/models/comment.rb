class Comment < ApplicationRecord
  # validate status implemented in app/models/concerns/visible.rb
  include Visible

  belongs_to :article
end
