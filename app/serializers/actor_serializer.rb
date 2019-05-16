class ActorSerializer < ActiveModel::Serializer
  attributes :id, :name, :birthday, :place_of_birth, :img_url, :imdb_id, :deathday, :biography, :movies

  def movies
    self.object.movies.map do |movie|
        {
          id: movie.id,
          title: movie.title,
          year: movie.year,
          media_type: movie.media_type,
          genres: movie.genres.map{ |genre| genre.name }
        }
    end
  end

end
