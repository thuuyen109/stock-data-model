# Data Modeling Overview

This project models a stock data ecosystem based on the provided ERD.

## Core Entities

- **STOCK_SYMBOLS**: Represents each stock with unique `symbol_id`.
- **COMPANY_PROFILES**: Company details linked to a stock.
- **INGESTION_SOURCES**: Sources from which intraday quotes are ingested.
- **QUOTE_INTRADAY**: Intraday stock prices with timestamp and source.
- **QUOTE_HISTORICAL**: Daily historical OHLCV prices.
- **REPORT_PERIOD**: Financial report periods for each company.
- **FINANCIAL_DICT**: Dictionary of financial metrics.
- **BALANCE_SHEET**, **INCOME_STATEMENT**, **CASHFLOW**, **MARKET_RATIOS**: Financial statements and market ratios per report period.

## Relationships

- STOCK_SYMBOLS → COMPANY_PROFILES, QUOTE_INTRADAY, QUOTE_HISTORICAL, REPORT_PERIOD
- INGESTION_SOURCES → QUOTE_INTRADAY
- FINANCIAL_DICT → BALANCE_SHEET, INCOME_STATEMENT, CASHFLOW, MARKET_RATIOS
- REPORT_PERIOD → BALANCE_SHEET, INCOME_STATEMENT, CASHFLOW, MARKET_RATIOS

## Modeling Goals

- Ensure strong referential integrity using primary and foreign keys
- Partition fact tables by time or report for query performance
- Standardize numeric types and timestamp fields
