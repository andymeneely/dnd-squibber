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

  def cr_to_xp(cr)
    case cr.to_r
      when 0r   then 10
      when 1/8r then 25
      when 1/4r then 50
      when 1/2r then 100
      when 1r   then 200
      when 2r   then 450
      when 3r   then 700
      when 4r   then 1100
      when 5r   then 1800
      when 6r   then 2300
      when 7r   then 2900
      when 8r   then 3900
      when 9r   then 5000
      when 10r  then 5900
    end
  end

end
