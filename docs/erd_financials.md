# Financial Reports

Models all structured financial report data including balance sheets, income statements, cashflow reports, and market ratios.

---
## FINANCIAL_DICT
Central dictionary for all financial metrics.
Key fields:
- `metric_id` — primary key
- `metric_code`, `name`, `en_name`
- `type`, `unit`, `order`

Used to ensure consistency across the four financial report tables.

---
## REPORT_PERIOD
Defines a company’s reporting period.
Key fields:
- `report_id` — primary key
- `symbol_id`, `symbol`
- `year_report`, `length_report`
- `created_at`

Acts as a parent table for all financial metrics.

---
## BALANCE_SHEET / INCOME_STATEMENT / CASHFLOW / MARKET_RATIOS

Four metric-value tables storing financial numbers.

Shared structure:

- `report_id` — foreign key
- `metric_id` — foreign key
- `metric_code`
- `year_report`, `length_report`
- `metric_value`

Used to:
- Build financial fact tables
- Calculate ratios and indicators
- Feed into analytics or ML models

---
## Relationships

- `FINANCIAL_DICT` 1—N each metric-value table
- `REPORT_PERIOD` 1—N each metric-value table