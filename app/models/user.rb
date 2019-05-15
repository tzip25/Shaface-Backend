class User < ApplicationRecord
  has_many :user_actors
  has_many :actors, through: :user_actors

  validates :username, uniqueness: true
  has_secure_password
end
