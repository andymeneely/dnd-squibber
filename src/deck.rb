require 'squib'
require_relative 'version'
require_relative 'dnd_api'

data = Squib.csv data:<<-EOCSV
Name
Goblin
Grick
Wolf
EOCSV

['Goblin', 'Grick', 'Wolf'].each.with_index do |name, i|
  monster = get_monster(name)
  monster.each do |key, value|
    data[key] ||= []
    data[key][i] = value
  end
  data['abilities'] ||= []
  data['abilities'][i] = <<~HEREDOC
    STR #{monster['strength'].to_s.ljust(2)    } (#{'%+d' % ((monster['strength'] - 10)/2.0).floor.to_s })
    DEX #{monster['dexterity'].to_s.ljust(2)   } (#{'%+d' % ((monster['dexterity'] - 10)/2.0).floor.to_s })
    CON #{monster['constitution'].to_s.ljust(2)} (#{'%+d' % ((monster['constitution'] - 10)/2.0).floor.to_s })
    INT #{monster['intelligence'].to_s.ljust(2)} (#{'%+d' % ((monster['intelligence'] - 10)/2.0).floor.to_s })
    WIS #{monster['wisdom'].to_s.ljust(2)      } (#{'%+d' % ((monster['wisdom'] - 10)/2.0).floor.to_s })
    CHA #{monster['charisma'].to_s.ljust(2)    } (#{'%+d' % ((monster['charisma'] - 10)/2.0).floor.to_s })
  HEREDOC
  data['action_text'] ||= []
  actions = monster['actions'].map do |a| 
    "<b>#{a['name']}</b>: #{a['desc']}"
  end
  data['action_text'][i] = actions.join("\n\n")
  data['special_text'] ||= []
  specials = monster['special_abilities'].map do |a| 
    "<b>#{a['name']}</b>: #{a['desc']}"
  end
  data['special_text'][i] = specials.join("\n\n")


end

File.open('data/monsters.txt', 'w+') { |f| f.write data.to_pretty_text }

Squib::Deck.new(width: '5in', height: '3in', cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/deck.yml'

  text layout: :name, str: data.name
  text layout: :size, str: data.size
  text layout: :armor_class, str: data.armor_class.map { |ac| "AC:  #{ac}" }
  text layout: :hit_points, str: data.hit_points.map { |hp| "HP:  #{hp}" }
  text layout: :speed, str: data.speed.map { |hp| "SPD: #{hp}" }
  text layout: :stealth, str: data.stealth.map { |s| "Stealth: #{s}" }

  text layout: :abilities, str: data.abilities

  text layout: :action_text, str: data.action_text
  text layout: :special_abilities, str: data.special_text

  text str: MySquibGame::VERSION, layout: :version

  build(:proofs) do
    safe_zone
    cut_zone
  end

  save format: :png

  build(:pnp) do
    save_sheet prefix: 'pnp_sheet_',
               trim: '0.125in',
               rows: 3, columns: 3
    save_pdf file: 'monsters.pdf', 
             width: '5in', height: '3in', 
             crop_stroke_color: :white
  end
  
end
