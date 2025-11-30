-- CREATE SCHEMA IF NOT EXISTS "staging";
-- CREATE SCHEMA IF NOT EXISTS "staging_dev";
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS "company_profiles" (
	"symbol_id" CHAR(64) NOT NULL,
	"symbol" VARCHAR(10) NOT NULL,
	"issue_share" BIGINT,
	"history" TEXT,
	"company_profile" TEXT,
	"icb_name3" VARCHAR(255) NOT NULL,
	"icb_name2" VARCHAR(255) NOT NULL,
	"icb_name4" VARCHAR(255) NOT NULL,
	"financial_ratio_issue_share" NUMERIC(20,4),
	"charter_capital" NUMERIC(20,4),
	"valid_from" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	"valid_to" TIMESTAMPTZ
);


CREATE TABLE IF NOT EXISTS "stock_symbols" (
	"symbol_id" CHAR(64) NOT NULL UNIQUE,
	"symbol" VARCHAR(10) NOT NULL,
	"exchange" VARCHAR(10) NOT NULL,
	"type" VARCHAR(10) NOT NULL,
	"organ_short_name" VARCHAR(255),
	"organ_name" VARCHAR(255) NOT NULL,
	"product_grp_id" VARCHAR(10) NOT NULL,
	"valid_from" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	"valid_to" TIMESTAMPTZ,
	PRIMARY KEY("symbol_id")
);


CREATE TABLE IF NOT EXISTS "ingestion_sources" (
	"source_id" INTEGER NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY,
	"source_name" VARCHAR(100) NOT NULL,
	"source_url" VARCHAR(255) NOT NULL,
	"is_active" BOOLEAN NOT NULL,
	"api_endpoint" TEXT,
	"frequency" VARCHAR(100),
	"last_checked_at" TIMESTAMPTZ,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY("source_id")
);


-- DROP TABLE quote_intraday;
CREATE TABLE IF NOT EXISTS "quote_intraday" (
	"symbol_id" CHAR(64) NOT NULL,
	"time" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	"symbol" VARCHAR(10) NOT NULL,
	"price" NUMERIC(10,1) NOT NULL,
	"volume" INTEGER NOT NULL,
	"match_type" VARCHAR(10) NOT NULL,
	"source_id" INTEGER NOT NULL
) PARTITION BY RANGE ("time");


-- DROP TABLE quote_historical;
CREATE TABLE IF NOT EXISTS "quote_historical" (
	"symbol_id" CHAR(64) NOT NULL,
	"time" TIMESTAMPTZ NOT NULL,
	"symbol" VARCHAR(10) NOT NULL,
	"open" NUMERIC(15,2) NOT NULL,
	"high" NUMERIC(15,2) NOT NULL,
	"low" NUMERIC(15,2) NOT NULL,
	"close" NUMERIC(15,2) NOT NULL,
	"volume" INTEGER NOT NULL
) PARTITION BY RANGE ("time");


CREATE TABLE IF NOT EXISTS "report_period" (
	"report_id" INTEGER NOT NULL UNIQUE GENERATED ALWAYS AS IDENTITY,
	"symbol_id" CHAR(64) NOT NULL,
	"symbol" VARCHAR(10) NOT NULL,
	"year_report" INTEGER NOT NULL,
	"length_report" SMALLINT NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY("report_id")
);


CREATE TABLE IF NOT EXISTS financial_dict (
    metric_id CHAR(64) NOT NULL UNIQUE,
    metric_code VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    en_name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    "order" INTEGER NOT NULL,
    unit VARCHAR(100) NOT NULL,
    -- Mã phân loại công ty mà chỉ số này áp dụng. Ví dụ BH, CK, NH, etc
    com_type_code VARCHAR(10) NOT NULL,
    PRIMARY KEY (metric_id),
    CONSTRAINT uq_metric_unique UNIQUE (metric_code, "order", com_type_code)
);



COMMENT ON COLUMN "financial_dict"."com_type_code" IS 'Mã phân loại công ty mà chỉ số này áp dụng. Ví dụ BH, CK, NH, etc';


-- DROP TABLE DROP TABLE balance_sheet;;
CREATE TABLE IF NOT EXISTS "balance_sheet" (
	"report_id" INTEGER NOT NULL,
	"metric_id" CHAR(64) NOT NULL,
	"metric_code" VARCHAR(100) NOT NULL,
	"year_report" INTEGER NOT NULL,
	"length_report" SMALLINT NOT NULL,
	"metric_value" NUMERIC(20,4) NOT NULL
) PARTITION BY RANGE ("year_report", "length_report");

COMMENT ON TABLE "balance_sheet" IS 'Các tài sản, nợ phải trả, vốn chủ sở hữu.

financial_dict.type IN (
''Chỉ tiêu cân đối kế toán'',
''Chỉ tiêu cơ cấu nguồn vốn''
)';

-- DROP TABLE cashflow;
CREATE TABLE IF NOT EXISTS "cashflow" (
	"report_id" INTEGER NOT NULL,
	"metric_id" CHAR(64) NOT NULL,
	"metric_code" VARCHAR(100) NOT NULL,
	"year_report" INTEGER NOT NULL,
	"length_report" SMALLINT NOT NULL,
	"metric_value" NUMERIC(20,4) NOT NULL
) PARTITION BY RANGE ("year_report", "length_report");

COMMENT ON TABLE "cashflow" IS 'Dòng tiền từ HĐKD, đầu tư, tài chính, dòng tiền thuần.

financial_dict.type IN (
''Chỉ tiêu lưu chuyển tiền tệ''
)';

-- DROP TABLE market_ratios;
CREATE TABLE IF NOT EXISTS "market_ratios" (
	"report_id" INTEGER NOT NULL,
	"metric_id" CHAR(64) NOT NULL,
	"metric_code" VARCHAR(100) NOT NULL,
	"year_report" INTEGER NOT NULL,
	"length_report" SMALLINT NOT NULL,
	"metric_value" NUMERIC(20,4) NOT NULL
) PARTITION BY RANGE ("year_report", "length_report");

COMMENT ON TABLE "market_ratios" IS 'PE, PB, PS, EV/EBITDA, current ratio, quick ratio...

financial_dict.type IN (
''Chỉ tiêu định giá'',
''Chỉ tiêu thanh khoản''
)';

-- DROP TABLE income_statement;
CREATE TABLE IF NOT EXISTS "income_statement" (
	"report_id" INTEGER NOT NULL,
	"metric_id" CHAR(64) NOT NULL,
	"metric_code" VARCHAR(100) NOT NULL,
	"year_report" INTEGER NOT NULL,
	"length_report" SMALLINT NOT NULL,
	"metric_value" NUMERIC(20,4) NOT NULL
) PARTITION BY RANGE ("year_report", "length_report");

COMMENT ON TABLE "income_statement" IS 'Doanh thu, lợi nhuận, biên lợi nhuận, ROE, ROA...

financial_dict.type IN (
''Chỉ tiêu kết quả kinh doanh'',
''Chỉ tiêu hiệu quả hoạt động'',
''Chỉ tiêu khả năng sinh lợi''
)';