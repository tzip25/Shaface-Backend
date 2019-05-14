class Actor < ApplicationRecord
  has_many :actor_movies
  has_many :movies, through: :actor_movies
  has_many :user_actors
  has_many :users, through: :user_actors
end
