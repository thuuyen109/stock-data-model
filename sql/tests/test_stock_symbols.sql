-- Ensure only one active symbol per (symbol, exchange, type)

SELECT symbol, exchange, type, COUNT(*)
FROM stock_symbols
WHERE valid_to IS NULL
GROUP BY 1,2,3
HAVING COUNT(*) > 1;

-- Test gen_symbol_id trigger function
INSERT INTO stock_symbols (symbol, exchange, type, organ_name, product_grp_id)
VALUES ('TEST', 'NYSE', 'EQUITY', 'Test Organization', 'PRD1');

SELECT symbol_id FROM stock_symbols WHERE symbol = 'TEST' AND exchange = 'NYSE' AND type = 'EQUITY';
DELETE FROM stock_symbols WHERE symbol = 'TEST' AND exchange = 'NYSE' AND type = 'EQUITY';
