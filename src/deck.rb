require 'squib'
require_relative 'version'
require_relative 'dnd_api'

data = Squib.csv data:<<-EOCSV
Name
Goblin
Grick
EOCSV

['Goblin', 'Grick'].each.with_index do |name, i|
  monster = get_monster(name)
  monster.each do |key, value|
    data[key] ||= []
    data[key][i] = value
  end
end

File.open('data/monsters.txt', 'w+') { |f| f.write data.to_pretty_text }

Squib::Deck.new(width: '5in', height: '3in', cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/deck.yml'

  text str: data.name, layout: :name

  svg file: 'example.svg'

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
  end
end
