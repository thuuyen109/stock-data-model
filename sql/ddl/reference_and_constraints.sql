ALTER TABLE "company_profiles"
ADD FOREIGN KEY("symbol_id") REFERENCES "stock_symbols"("symbol_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "quote_intraday"
ADD FOREIGN KEY("symbol_id") REFERENCES "stock_symbols"("symbol_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "quote_historical"
ADD FOREIGN KEY("symbol_id") REFERENCES "stock_symbols"("symbol_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "report_period"
ADD FOREIGN KEY("symbol_id") REFERENCES "stock_symbols"("symbol_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "quote_intraday"
ADD FOREIGN KEY("source_id") REFERENCES "ingestion_sources"("source_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "balance_sheet"
ADD FOREIGN KEY("report_id") REFERENCES "report_period"("report_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "income_statement"
ADD FOREIGN KEY("report_id") REFERENCES "report_period"("report_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "cashflow"
ADD FOREIGN KEY("report_id") REFERENCES "report_period"("report_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "market_ratios"
ADD FOREIGN KEY("report_id") REFERENCES "report_period"("report_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE "balance_sheet"
ADD FOREIGN KEY("metric_id") REFERENCES "financial_dict"("metric_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "income_statement"
ADD FOREIGN KEY("metric_id") REFERENCES "financial_dict"("metric_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "cashflow"
ADD FOREIGN KEY("metric_id") REFERENCES "financial_dict"("metric_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "market_ratios"
ADD FOREIGN KEY("metric_id") REFERENCES "financial_dict"("metric_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;