require 'rest-client'
require 'json'

def get_monster(name)
  search = RestClient.get 'http://dnd5eapi.co/api/monsters',
                          {params: {name: name}}
  begin
    url = JSON.parse(search.body)["results"][0]["url"]
  rescue
    require 'irb';binding.irb
  end
  puts "URL is: #{url}"
  response = RestClient.get url
  JSON.parse(response.body)
end

def foo
  'blah'
end