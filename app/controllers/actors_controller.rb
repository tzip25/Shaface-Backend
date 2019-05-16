require 'uri'
require 'net/http'
require 'rest-client'
require 'date'

class ActorsController < ApplicationController

  def index
    actors = Actor.all
    render json: actors
  end

  def create_movies_and_genres(tmdb_id, new_actor)
    tmdb_creds_url = URI("https://api.themoviedb.org/3/person/#{tmdb_id}/combined_credits?language=en-US&api_key=61f1a408f4732dfbc73bad3e452b9a41")
    tmdb_creds_res = Net::HTTP.get_response(tmdb_creds_url).body
    tmdb_cred = JSON.parse(tmdb_creds_res)
    # iterate through results to create a movie instance for each, a genre instance for each
    # and a movie_genres association for each
    tmdb_cred["cast"].each do |movie|
      #create movie instance for each one
      found_movie = Movie.find_or_create_by(tmdb_id: movie["id"], title: movie["title"] || movie["name"], year: movie["release_date"] || movie["first_air_date"], media_type: movie["media_type"])
      new_actor.movies << found_movie
      #check if movie has genres listed,
      # if so, create genre instance and associate with movie
      if movie["genre_ids"].length > 0
        movie["genre_ids"].each do |genre|
          found_genre = Genre.find_by(tmdb_id: genre)
          found_genre ? found_movie.genres << found_genre : nil
        end
      end
    end
  end

  def create_actor_object(actor_name)
    spacedName = actor_name.split(" ").join("+")

    # get actore IMDB id
    res = RestClient.get("https://v2.sg.media-imdb.com/suggests/#{actor_name[0]}/#{spacedName}.json")
    body = res.body
    cleaned = body.split(/(\{.*\})/m)[1]
    json = JSON.parse(cleaned)

    new_actor = nil

    begin
      imdb_image_url = json["d"][0]["i"][0]
      imdb_id = json["d"][0]["id"]

      # use IMDB id to get actor TMDB id
      tmdb_id_url = URI("https://api.themoviedb.org/3/find/#{imdb_id}?external_source=imdb_id&language=en-US&api_key=61f1a408f4732dfbc73bad3e452b9a41")
      tmdb_id_res = Net::HTTP.get_response(tmdb_id_url).body
      tmdb_id = JSON.parse(tmdb_id_res)["person_results"][0]["id"]

      # use TMDB id to get actor TMDB details including bday, bio and birthplace
      tmdb_info_url = URI("https://api.themoviedb.org/3/person/#{tmdb_id}?language=en-US&api_key=61f1a408f4732dfbc73bad3e452b9a41")
      tmdb_info_res = Net::HTTP.get_response(tmdb_info_url).body
      tmdb_info = JSON.parse(tmdb_info_res)

      # change bday to user readable format
      bday = Date.parse(tmdb_info["birthday"])
      sting_bday = bday.strftime("%b %d %Y")

      # change dday (if actor is decesased) to user readable format
      string_dday = nil
      if tmdb_info["deathday"]
        dday = Date.parse(tmdb_info["deathday"])
        string_dday = dday.strftime("%b %d %Y")
      end

      # create desired actor object, store in database and pass to frontend
      actor_profile = {}
      actor_profile["name"] = actor_name
      actor_profile["img_url"] = imdb_image_url
      actor_profile["birthday"] = sting_bday
      actor_profile["deathday"] = string_dday
      actor_profile["biography"] = tmdb_info["biography"]
      actor_profile["place_of_birth"] = tmdb_info["place_of_birth"]
      actor_profile["imdb_id"] = imdb_id

      new_actor = Actor.create(actor_profile)

      # use TMDB id toget actor TMDB movie credits
      create_movies_and_genres(tmdb_id, new_actor)
      new_actor
    rescue
      new_actor
    end
  end



  def create
    actor_name = params["name"]
    # check if actor already exists in our database
    # if so, return actor instance and don't run API fetches
    found_actor = Actor.find_by(name: actor_name)
    if found_actor
      render json: found_actor
    # if actor is not in our database, create the object we need
    # store it in our database and then render that to frontend
    else
      begin
        new_actor = create_actor_object(actor_name)
        render json: new_actor
      rescue
        render json: ["no actor found"]
      end
    end
  end


end
