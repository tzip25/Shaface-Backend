class MoviesController < ApplicationController

  #baconize feature - find actor movie associations
  def index

    movieArr = []
    filteredArr = []
    #iterate over current user's actors and then over each actor's movies
    curr_user.actors.map do |actor|
      actor.movies.map do |movie|
        movieHash = {}
        #create hash for each movie
        movieHash["media_type"] = movie.media_type
        movieHash["year"] = movie.year
        movieHash["title"] = movie.title
        movieHash["actors"] = movie.actors.map{|actor| {id: actor.id, name: actor.name, img: actor.img_url} }
        movieHash[movie.id] ||= 0
        movieHash[movie.id] += 1

        if movieHash["actors"].length > 1 && movieHash["media_type"] == "movie"
          movieArr << movieHash
        end

      end
    end

    movieArr.each do |movie|
      begin
        if !!curr_user.actors.find(movie["actors"].map{|actor| actor[:id]})
          filteredArr << movie
        end
      rescue
      end
    end

    render json: filteredArr.uniq
  end

end
