class MoviesController < ApplicationController

  def index

    movieArr = []

    # histogram = curr_user.actors.each_with_object({}) do |actor, obj|
    #     actor.movies.each do |movie|
    #     obj[movie.id] ||= 0
    #     obj[movie.id] += 1
    #   end
    # end
    #
    # val = histogram.select do |k, v|
    #   v > 1
    # end
    # byebug
    # [[1, 2], [13, 4]]
    # [1, 13]
    # Movie.find(ids)

    # movie.actors.where('actors.id IN [(?)]', curr_user.actors.pluck(:id))
    # movie.actors & curr_user.actors

    curr_user.actors.map do |actor|
      actor.movies.map do |movie|
        movieHash = {}

        movieHash["media_type"] = movie.media_type
        movieHash["year"] = movie.year
        movieHash["title"] = movie.title
        movieHash["actors"] = movie.actors.map{|actor| {name: actor.name, img: actor.img_url} }
        movieHash[movie.id] ||= 0
        movieHash[movie.id] += 1

        if movieHash["actors"].length > 1 && movieHash["media_type"] == "movie"
          movieArr << movieHash
        end

      end

    end
    render json: movieArr.uniq
  end

end
