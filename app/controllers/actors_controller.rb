require 'uri'
require 'net/http'
require 'rest-client'
require 'date'

class ActorsController < ApplicationController

  def index

  end

  def create
    actor_name = params["name"]

    # check if actor already exists in our table
    # if so don't run API fetches, and just return that actor instance
    found_actor = Actor.find_by(name: actor_name)
    if found_actor
      render json: found_actor

    # if actor is not in our database, create the object we need
    # store it in our database and then render that to frontend
    else
      spacedName = actor_name.split(" ").join("+")

      # get actore IMDB id
      res = RestClient.get("https://v2.sg.media-imdb.com/suggests/#{actor_name[0]}/#{spacedName}.json")
      body = res.body
      cleaned = body.split(/(\{.*\})/m)[1]
      json = JSON.parse(cleaned)
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

      # use TMDB id toget actor TMDB movie credits
      tmdb_creds_url = URI("https://api.themoviedb.org/3/person/#{tmdb_id}/combined_credits?language=en-US&api_key=61f1a408f4732dfbc73bad3e452b9a41")
      tmdb_creds_res = Net::HTTP.get_response(tmdb_creds_url).body
      tmdb_cred = JSON.parse(tmdb_creds_res)

      # change bday to user readable format
      bday = Date.parse(tmdb_info["birthday"])
      sting_bday = bday.strftime("%b %d %Y")

      # change dday - if actor is decesased - to user readable format
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

      found_actor = Actor.create(actor_profile)
      render json: found_actor
    end
  end

  def update
  end

end
