# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TownhallScraper do
  describe '.get_townhall_email' do
    it 'retourne un email valide pour une mairie connue (Ableiges)' do
      url = 'https://lannuaire.service-public.gouv.fr/ile-de-france/val-d-oise/55e63c96-f8a4-424c-a9fd-52ddf515b6ef'
      email = TownhallScraper.get_townhall_email(url)

      expect(email).not_to be_nil
      expect(email).to include('@')
      expect(email).to include('ableiges')
    end

    it 'retourne nil si pas d\'email trouvé' do
      # URL invalide
      email = TownhallScraper.get_townhall_email('https://lannuaire.service-public.gouv.fr/invalid-url')
      expect(email).to be_nil
    end
  end

  describe '.get_townhall_urls' do
    before(:all) do
      @urls = TownhallScraper.get_townhall_urls
    end

    it 'retourne un array non vide' do
      expect(@urls).to be_an(Array)
      expect(@urls).not_to be_empty
    end

    it 'chaque élément contient une url et un nom de ville' do
      @urls.first(5).each do |townhall|
        expect(townhall).to have_key(:url)
        expect(townhall).to have_key(:city)
        expect(townhall[:url]).to start_with('http')
        expect(townhall[:city].length).to be > 0
      end
    end

    it 'les urls pointent vers le Val d\'Oise' do
      @urls.each do |townhall|
        expect(townhall[:url]).to include('val-d-oise')
      end
    end
  end

  describe '.get_all_townhalls_emails' do
    before(:all) do
      @result = TownhallScraper.get_all_townhalls_emails
    end

    it 'retourne un array de hashs' do
      expect(@result).to be_an(Array)
      @result.each do |item|
        expect(item).to be_a(Hash)
      end
    end

    it 'retourne au moins quelques emails' do
      expect(@result.length).to be >= 5
    end

    it 'chaque hash contient une ville et un email valide' do
      @result.first(5).each do |item|
        city = item.keys.first
        email = item.values.first

        expect(city).to be_a(String)
        expect(city.length).to be > 0
        expect(email).to include('@')
      end
    end
  end
end
