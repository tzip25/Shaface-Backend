class UserActor < ApplicationRecord
  belongs_to :actor
  belongs_to :user
end
