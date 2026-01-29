# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'json'

class CryptoScraper
  BASE_URL = 'https://coinmarketcap.com/all/views/all/'

  def self.get_all_crypto_prices
    puts "Connexion à CoinMarketCap..."

    response = HTTParty.get(BASE_URL, headers: {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    })

    puts "Page récupérée, parsing en cours..."

    doc = Nokogiri::HTML(response.body)
    crypto_array = []

    script_tag = doc.at_css('script#__NEXT_DATA__')

    unless script_tag
      puts "Erreur: script __NEXT_DATA__ non trouvé"
      return crypto_array
    end

    json_data = JSON.parse(script_tag.text)

    # initialState est un JSON encodé en string
    initial_state_str = json_data.dig('props', 'initialState')

    unless initial_state_str.is_a?(String)
      puts "Erreur: initialState n'est pas une string"
      return crypto_array
    end

    initial_state = JSON.parse(initial_state_str)
    listing_data = initial_state.dig('cryptocurrency', 'listingLatest', 'data')

    unless listing_data.is_a?(Array) && listing_data.length > 1
      puts "Erreur: données de listing non trouvées"
      return crypto_array
    end

    # Le premier élément contient le schema (keysArr)
    keys_arr = listing_data.first['keysArr']

    # Trouver les index des champs qui nous intéressent
    symbol_index = keys_arr.index('symbol')
    price_index = keys_arr.index('quote.USD.price')

    puts "Index symbol: #{symbol_index}, Index price: #{price_index}"

    # Parcourir les éléments de données (à partir du 2ème)
    listing_data[1..].each do |crypto_data|
      next unless crypto_data.is_a?(Array)

      symbol = crypto_data[symbol_index]
      price = crypto_data[price_index]&.round(2)

      next unless symbol && price

      crypto_array << { symbol => price }
      puts "#{symbol} => $#{price}"
    end

    puts "\nTotal: #{crypto_array.length} cryptomonnaies récupérées"
    crypto_array
  end
end

# Exécution directe pour test
if __FILE__ == $PROGRAM_NAME
  result = CryptoScraper.get_all_crypto_prices
  puts "\nRésultat final (5 premiers):"
  puts result.first(5).inspect
end
