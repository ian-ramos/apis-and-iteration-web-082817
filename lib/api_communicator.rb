require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.

  while character_hash #while character_hash is a hash (aka not nil) run this code
    film_urls = character_hash["results"].find do |hash| #returns the hash if it finds the character
      hash["name"].downcase == character
    end
    if film_urls
      return film_urls["films"].map do |film| #if there is data, it returns this and breaks the loop, otherwise it keeps looping
        JSON.parse(RestClient.get(film))
      end
    end
    character_hash = character_hash["next"] ? JSON.parse(RestClient.get(character_hash["next"])) : nil #before the loop restarts, it checks if the character_hash["next"] has a url.
    #If it does, then it sets it equal to that variable.  Otherwise, it sets it to nil so that the while loop breaks
  end
end

def parse_character_movies(films_array)
  # some iteration magic and puts out the movies in a nice list
  films_array.each do |film|
    puts film["title"]
  end
end

def show_character_movies(character)
  films_array = get_character_movies_from_api(character)
  if !films_array
    puts "That's not a character!"
  else
    parse_character_movies(films_array)
  end
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
