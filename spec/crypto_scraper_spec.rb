# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CryptoScraper do
  describe '.get_all_crypto_prices' do
    before(:all) do
      # Exécuter une seule fois pour éviter de surcharger le serveur
      @result = CryptoScraper.get_all_crypto_prices
    end

    it 'retourne un array non vide' do
      expect(@result).to be_an(Array)
      expect(@result).not_to be_empty
    end

    it 'retourne un array de hashs' do
      @result.each do |item|
        expect(item).to be_a(Hash)
      end
    end

    it 'contient des cryptos connues (BTC, ETH)' do
      symbols = @result.map { |h| h.keys.first }
      expect(symbols).to include('BTC')
      expect(symbols).to include('ETH')
    end

    it 'retourne au moins 100 cryptomonnaies' do
      expect(@result.length).to be >= 100
    end

    it 'chaque hash contient un symbole et un prix numérique' do
      @result.first(10).each do |crypto|
        symbol = crypto.keys.first
        price = crypto.values.first

        expect(symbol).to be_a(String)
        expect(symbol.length).to be > 0
        expect(price).to be_a(Numeric)
      end
    end
  end
end
