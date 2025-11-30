/* Table stock_symbol */
-- This index ensures that only one record exists for any given (symbol, exchange, type) where the valid_to column is NULL (i.e., the record is currently active).
CREATE UNIQUE INDEX uq_symbol_active
ON "stock_symbols" (symbol, exchange, "type")
WHERE valid_to IS NULL;

CREATE OR REPLACE FUNCTION gen_symbol_id()
RETURNS TRIGGER AS $$
BEGIN
    -- Nếu symbol_id chưa có, gen SHA-256 hash
    IF NEW.symbol_id IS NULL THEN
        NEW.symbol_id := encode(
            digest(
                NEW.symbol || '_' || NEW.exchange || '_' || NEW.type || '_' || to_char(NEW.valid_from, 'YYYY-MM-DD'),
                'sha256'
            ),
            'hex'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stock_symbols_id
BEFORE INSERT OR UPDATE ON stock_symbols
FOR EACH ROW
EXECUTE FUNCTION gen_symbol_id();


-----------------------------------------------------
/* Table financial_dict */
CREATE OR REPLACE FUNCTION gen_metric_id()
RETURNS TRIGGER AS $$
BEGIN
    -- Nếu metric_id chưa có, gen SHA-256 hash
    IF NEW.metric_id IS NULL THEN
        NEW.metric_id := encode(
            digest(
                NEW.metric_code || '_' || NEW."order" || '_' || NEW.com_type_code,
                'sha256'
            ),
            'hex'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_financial_dict_id
BEFORE INSERT OR UPDATE ON financial_dict
FOR EACH ROW
EXECUTE FUNCTION gen_metric_id();