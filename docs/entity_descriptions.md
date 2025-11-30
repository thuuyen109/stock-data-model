# Entity Descriptions

Detailed explanation of all entities based on the ERD.


## STOCK_SYMBOLS

Catalog of all listed and delisted stock symbols.

- **Primary Key**: `symbol_id`
- Includes: organization name, exchange, product group, validity range.
- Serves as the core dimension for joining price data and financial reports.


## COMPANY_PROFILES

Company profile information.

- Joined via: `symbol_id`
- Contains: ICB sectors, company history, business description, charter capital.


## INGESTION_SOURCES

Catalog of all data ingestion sources.

- Includes: source name, API endpoint, frequency, active flag.
- Primarily used for tracking intraday price data ingestion.


## QUOTE_INTRADAY

Real-time or intraday price data (per second/minute).

- **Composite Key**: (`symbol_id`, `time`)
- References: `source_id`
- Used for backtesting engines and real-time dashboards.


## QUOTE_HISTORICAL

Daily OHLCV historical market data.

- **Composite Key**: (`symbol_id`, `time`)
- Used to build long-term price fact tables and ML features.


## FINANCIAL_DICT

Dictionary of all financial metrics.

- **Primary Key**: `metric_id`
- Includes: metric code, English name, metric type, reporting unit.
- Shared reference table for all financial metric datasets.


## REPORT_PERIOD

Represents a financial reporting period.

- **Primary Key**: `report_id`
- Includes: report year, report length (quarter/year), symbol.
- Parent entity for all four financial report tables.


## BALANCE_SHEET / INCOME_STATEMENT / CASHFLOW / MARKET_RATIOS

Four tables containing structured financial metrics.

- **Key**: (`report_id`, `metric_id`)
- `metric_value` stores the numeric value of each financial metric.
- Used to construct financial fact tables and downstream analytics marts.