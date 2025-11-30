-- Detect duplicate report_period rows

SELECT symbol_id, year_report, length_report, COUNT(*)
FROM report_period
GROUP BY 1,2,3
HAVING COUNT(*) > 1;
