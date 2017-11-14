require 'rest-client'
require 'json'

class DnDAPI

  def initialize
    @monster_cache = {}
  end

  def hit_api(url, name)
    puts "Searching for: #{name}"
    search = RestClient.get url, {params: {name: name}}
    url = JSON.parse(search.body)["results"][0]["url"]
    puts "Downloading: #{url}"
    response = RestClient.get url
    JSON.parse(response.body)
  end

  def get_monster(name)
    @monster_cache[name] ||= hit_api('http://dnd5eapi.co/api/monsters', name)
    return @monster_cache[name]
  end

end
