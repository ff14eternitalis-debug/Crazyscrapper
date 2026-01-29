# frozen_string_literal: true

require 'nokogiri'
require 'httparty'

class TownhallScraper
  BASE_URL = 'https://lannuaire.service-public.gouv.fr'
  VAL_DOISE_URL = 'https://lannuaire.service-public.gouv.fr/navigation/ile-de-france/val-d-oise/mairie'

  def self.get_townhall_email(townhall_url)
    response = HTTParty.get(townhall_url, headers: {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    })

    doc = Nokogiri::HTML(response.body)

    # Chercher tous les liens mailto et filtrer les vrais emails
    mailto_links = doc.css('a[href^="mailto:"]')

    mailto_links.each do |link|
      href = link['href']
      # Extraire l'email du href
      email = href.gsub('mailto:', '').split('?').first.strip

      # Vérifier que c'est un vrai email (contient @ et pas vide)
      return email if email.include?('@') && email.length > 3
    end

    nil
  end

  def self.get_townhall_urls
    puts "Récupération de la liste des mairies du Val d'Oise..."

    response = HTTParty.get(VAL_DOISE_URL, headers: {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    })

    doc = Nokogiri::HTML(response.body)
    townhalls = []

    # Chercher tous les liens vers les mairies du Val d'Oise
    links = doc.css('a[href*="/ile-de-france/val-d-oise/"]')

    links.each do |link|
      href = link['href']
      text = link.text.strip

      # Ignorer les liens de navigation
      next if href.include?('/navigation/')
      next unless text.include?('Mairie')

      # Extraire le nom de la ville (format: "Mairie - Ville")
      city_name = text.gsub(/^Mairie\s*-\s*/, '').strip

      townhalls << {
        url: href.start_with?('http') ? href : "#{BASE_URL}#{href}",
        city: city_name
      }

      puts "Trouvé: #{city_name}"
    end

    puts "#{townhalls.length} mairies trouvées"
    townhalls
  end

  def self.get_all_townhalls_emails
    puts "Démarrage du scraping des mairies du Val d'Oise...\n\n"

    townhalls = get_townhall_urls
    results = []

    townhalls.each_with_index do |townhall, index|
      city = townhall[:city]
      url = townhall[:url]

      puts "[#{index + 1}/#{townhalls.length}] Récupération de l'email de #{city}..."

      email = get_townhall_email(url)

      if email
        results << { city => email }
        puts "  -> #{email}"
      else
        puts "  -> Pas d'email trouvé"
      end

      # Pause pour ne pas surcharger le serveur
      sleep(0.3)
    end

    puts "\n\nTotal: #{results.length} emails récupérés sur #{townhalls.length} mairies"
    results
  end
end

# Exécution directe pour test
if __FILE__ == $PROGRAM_NAME
  result = TownhallScraper.get_all_townhalls_emails
  puts "\nRésultat final (5 premiers):"
  puts result.first(5).inspect
end
