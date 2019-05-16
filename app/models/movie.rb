class Movie < ApplicationRecord
  has_many :actor_movies
  has_many :actors, through: :actor_movies
  has_many :movie_genres
  has_many :genres, through: :movie_genres
end
