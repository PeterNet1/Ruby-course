require 'yaml'

skeptic_file = YAML.load_file('./skeptic.yml')
skeptic_hash = skeptic_file.to_h
skeptic_options = ""

skeptic_hash.each_key do |option|
  if skeptic_hash[option].to_s.match(/\d/)
    skeptic_options += "--#{option.gsub(/_/, '-')} #{skeptic_hash[option]} "
  elsif skeptic_hash[option] == true
    skeptic_options += "--#{option.gsub(/_/, '-')} "
  else
    skeptic_options += "--#{option.gsub(/_/, '-')}='#{skeptic_hash[option]}' "
  end
end

exec "skeptic #{skeptic_options} card_games.rb"
