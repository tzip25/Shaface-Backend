class ActorSerializer < ActiveModel::Serializer
  attributes :id, :name, :birthday, :place_of_birth, :img_url, :imdb_id, :deathday, :biography, :movies

  def movies
    movieObj = self.object.movies.map do |movie|
      if movie.year
        {
          id: movie.id,
          title: movie.title,
          year: movie.year,
          media_type: movie.media_type,
          genres: movie.genres.map{ |genre| genre.name }
        }
      end
    end
    sorted = movieObj.compact.sort_by{ |mov| mov[:year] }
    sorted.reverse[0, 25]
  end

end
