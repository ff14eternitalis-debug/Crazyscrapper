# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DeputyScraper do
  describe '.get_all_deputies' do
    before(:all) do
      @result = DeputyScraper.get_all_deputies
    end

    it 'retourne au moins 500 députés' do
      expect(@result).to be_an(Array)
      expect(@result.length).to be >= 500
    end

    it 'chaque député a un prénom, nom et email valide' do
      @result.first(10).each do |deputy|
        expect(deputy).to have_key('first_name')
        expect(deputy).to have_key('last_name')
        expect(deputy).to have_key('email')

        expect(deputy['first_name']).to be_a(String)
        expect(deputy['first_name'].length).to be > 0

        expect(deputy['last_name']).to be_a(String)
        expect(deputy['last_name'].length).to be > 0

        expect(deputy['email']).to include('@')
      end
    end
  end
end
