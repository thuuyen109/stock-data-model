# Raw Layer

This diagram represents the raw ingestion layer of the stock data system.
Tables in this layer store data exactly as received from upstream providers, with minimal preprocessing.

---
## STOCK_SYMBOLS
Stores all stock symbols with metadata such as exchange, organization info, product grouping, and validity intervals.
Key fields:
- `symbol_id` — surrogate primary key
- `symbol` — stock ticker
- `exchange`, `type`, `product_grp_id`
- `organ_name`, `organ_short_name`
- `valid_from`, `valid_to`

---
## COMPANY_PROFILES
Contains company-level metadata for each stock symbol.
Key fields:
- `symbol_id` — `foreign key`
- `issue_share`, `charter_capital`
- `history`, `company_profile`
- Industry classification (ICB level 2/3/4)

---
## INGESTION_SOURCES

Registry of raw data providers and ingestion configurations.

Key fields:

source_id — primary key

source_name, source_url

frequency

api_endpoint

is_active

Used to track data lineage for intraday market data.

Relationships

STOCK_SYMBOLS 1—N COMPANY_PROFILES

INGESTION_SOURCES 1—N QUOTE_INTRADAY