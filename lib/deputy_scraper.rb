# frozen_string_literal: true

require 'httparty'
require 'csv'

class DeputyScraper
  CSV_URL = 'https://www.voxpublic.org/spip.php?page=csv-deputes'

  def self.get_all_deputies
    puts "Téléchargement de la liste des députés depuis VoxPublic..."

    response = HTTParty.get(CSV_URL, headers: {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    })

    unless response.code == 200
      puts "Erreur: impossible de télécharger le CSV (#{response.code})"
      return []
    end

    puts "CSV récupéré, parsing en cours..."

    deputies = []

    # Parser le CSV avec options tolérantes
    csv_data = CSV.parse(response.body, headers: true, liberal_parsing: true)

    csv_data.each do |row|
      first_name = row['prenom']&.strip
      last_name = row['nom']&.strip
      email = row['email']&.strip

      # Ignorer les lignes sans données essentielles
      next unless first_name && last_name && email && email.include?('@')

      deputy = {
        'first_name' => first_name,
        'last_name' => last_name,
        'email' => email
      }

      deputies << deputy
      puts "#{first_name} #{last_name} => #{email}"
    end

    puts "\nTotal: #{deputies.length} députés récupérés"
    deputies
  end
end

# Exécution directe pour test
if __FILE__ == $PROGRAM_NAME
  result = DeputyScraper.get_all_deputies
  puts "\nRésultat final (5 premiers):"
  result.first(5).each do |deputy|
    puts deputy.inspect
  end
end
