# Stock Data Modeling

This repository contains a complete analytical data model for building a reliable and query-friendly stock market dataset.  
The goal is to demonstrate data modeling skills using clear dimensional design, clean DDL, and well-defined tests.

The project models three core domains:
- **Company fundamentals**
- **Daily stock prices (OHLCV)**
- **Financial statements**

The repo focuses on:
- Entity Relationship Diagrams (ERDs)
- Dimensional modeling
- DDL for table creation
- Data quality tests

This project does *not* include ingestion pipelines, orchestration, or machine learning.  


---
## Project Structure

---
## Objectives

- Design a clean analytical schema for stock data
- Define clear entities and relationships
- Provide reproducible DDL for database creation
- Demonstrate test coverage and quality checks
- Enable analysts, quants, or ML teams to query reliable data

---
## Design Principles

- Use normalized modeling **(3NF)** for reference and financial data.
- Apply temporal modeling using valid_from / valid_to for symbol metadata.
- **Partition** large fact tables (intraday, historical, financials) by time for performance.
- Ensure **surrogate keys** are generated deterministically via pgcrypto.
- Enforce model integrity using **foreign key** constraints and uniqueness rules.

---
## Use Cases Supported

- Time-series forecasting (LSTM, Prophet, ARIMA)
- Market analytics (OHLCV, volatility, liquidity analysis)
- Financial ratio calculations from multi-statement data
- Corporate actions & sector classification analysis

---
## Limitations & Future Extensions

The current data model focuses primarily on basic OHLCV (Open, High, Low, Close, Volume) stock data. The following features and improvements should be considered for future development:

### Future Extensions

**1. Support for Corporate Actions (Dividends, Splits)**

This is a **mandatory requirement** to accurately calculate **Total Return** and correctly adjust historical stock prices. We will need to implement dedicated event tables (Fact Tables) to record and apply changes related to dividends and stock split/reverse split ratios.

**2. Add Dimension Tables for Sector / Industry Hierarchies**

Classifying companies by their Sector and Industry is crucial for effective group analysis. This descriptive data should be normalized into separate **Dimension Tables** to improve the efficiency of filtering, grouping, and analytical queries on the main fact tables.

**3. Add Materialized Views for Daily Aggregates**

To accelerate queries for frequently calculated technical indicators and aggregate metrics (e.g., Moving Averages, RSI), we should define and materialize these views. This offloads computational burden by pre-calculating and physically storing the results.

**4. Consider ClickHouse for Intraday Data at Scale**

Intraday data (minute-by-minute or tick data) is extremely high-volume and inherently time-series in nature. We should consider using columnar database management systems like **ClickHouse** to ensure high-performance storage and analytical query speed for large-scale granular data.
