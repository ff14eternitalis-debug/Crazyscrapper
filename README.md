# Crazyscrapper

Projet de scraping web en Ruby.

## Installation

```bash
bundle install
```

## Exercices

### 1. Dark Trader (crypto_scraper.rb)
Récupère le cours des cryptomonnaies depuis CoinMarketCap.

```ruby
require_relative 'lib/crypto_scraper'
CryptoScraper.get_all_crypto_prices
```

### 2. Mairie Christmas (townhall_scraper.rb)
Récupère les emails des mairies du Val d'Oise.

```ruby
require_relative 'lib/townhall_scraper'
TownhallScraper.get_all_townhalls_emails
```

### 3. Bonus - Députés (deputy_scraper.rb)
Récupère la liste des députés de France avec leurs emails.

```ruby
require_relative 'lib/deputy_scraper'
DeputyScraper.get_all_deputies
```

## Tests

```bash
bundle exec rspec
```

## Structure

```
lib/
├── crypto_scraper.rb
├── townhall_scraper.rb
└── deputy_scraper.rb
spec/
├── spec_helper.rb
├── crypto_scraper_spec.rb
├── townhall_scraper_spec.rb
└── deputy_scraper_spec.rb
```
