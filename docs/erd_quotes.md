# Quotes Layer

Contains two datasets representing stock market prices: intraday quotes and historical OHLCV data.

---
## QUOTE_INTRADAY
Intraday (real-time) quote data at second/minute granularity.

Key fields:
- `time` — part of composite primary key
- `symbol_id` — foreign key
- `symbol`
- `price`, `volume`
- `match_type`
- `source_id` — ingestion lineage

Used for:
- Real-time dashboards
- High-frequency backtesting
- Intraday anomaly detection

---
## QUOTE_HISTORICAL
Daily OHLCV market data.

Key fields:
- `time`
- `open`, `high`, `low`, `close`, `volume`
- `symbol_id`, `symbol`

Used for:
- Long-term trend analysis
- ML feature generation
- Training predictive models

---
## Relationships

- `STOCK_SYMBOLS` 1—N `QUOTE_INTRADAY`
- `STOCK_SYMBOLS` 1—N `QUOTE_HISTORICAL`
- `INGESTION_SOURCES` 1—N `QUOTE_INTRADAY`