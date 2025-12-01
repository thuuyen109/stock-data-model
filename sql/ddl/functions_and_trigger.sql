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


-----------------------------------------------------
/* Partition on Postgres, control partition by pg_parman */
CREATE OR REPLACE FUNCTION stg_dev.create_dynamic_partitions(
    p_schema_name TEXT,
    p_parent_table_name TEXT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS VOID AS $$
DECLARE
    p_date DATE;
    next_date DATE;
    parent_fqn TEXT;      -- Fully Qualified Name: "schema"."table"
    partition_table_name TEXT; -- Just the base name: table_2017_01
    partition_fqn TEXT;   -- Fully Qualified Name for partition: "schema"."table_2017_01"
    sql_command TEXT;
BEGIN
    -- 1. Thiết lập Tên Đủ Điều kiện của Bảng Cha (vẫn dùng %I.%I)
    parent_fqn := format('%I.%I', p_schema_name, p_parent_table_name);

    -- 2. Đảm bảo ngày bắt đầu là ngày đầu tiên của tháng
    p_date := date_trunc('month', p_start_date)::DATE;

    WHILE p_date <= p_end_date LOOP
        next_date := p_date + INTERVAL '1 month';

        -- Tên bảng con (CHỈ TÊN BẢNG, KHÔNG CÓ SCHEMA VÀ DẤU NGOẶC KÉP)
        -- Ví dụ: reviews_2017_01
        partition_table_name := format('%s_%s', p_parent_table_name, to_char(p_date, 'YYYYMM'));

        -- Tên đủ điều kiện của bảng con (Dùng %I.%I để trích dẫn toàn bộ tên)
        -- Ví dụ: "airbnb_prod"."reviews_2017_01"
        partition_fqn := format('%I.%I', p_schema_name, partition_table_name);

        -- Cú pháp CREATE TABLE ... PARTITION OF ...
        -- Sử dụng %s cho partition_fqn và parent_fqn vì chúng đã được định dạng hoàn chỉnh ở trên.
        sql_command := format(
            'CREATE TABLE IF NOT EXISTS %s PARTITION OF %s '
            'FOR VALUES FROM (%L) TO (%L);',
            partition_fqn,
            parent_fqn,
            p_date,
            next_date
        );

        EXECUTE sql_command;
        RAISE NOTICE 'Done created partition table: %', partition_fqn;

        p_date := next_date;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT stg_dev.create_dynamic_partitions(
    'dev',
    'quote_intraday',
    '2014-01-01',
    '2016-12-30'
);
