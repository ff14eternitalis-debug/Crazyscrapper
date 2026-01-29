# Crazyscrapper

Web scraping project in Ruby.

## Installation

```bash
bundle install
```

## Scrapers

### 1. Crypto Scraper (crypto_scraper.rb)
Fetches cryptocurrency prices from CoinMarketCap.

```ruby
require_relative 'lib/crypto_scraper'
CryptoScraper.get_all_crypto_prices
```

### 2. Townhall Scraper (townhall_scraper.rb)
Fetches email addresses of townhalls in Val d'Oise (France).

```ruby
require_relative 'lib/townhall_scraper'
TownhallScraper.get_all_townhalls_emails
```

### 3. Deputy Scraper (deputy_scraper.rb)
Fetches the list of French parliament members with their emails.

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
