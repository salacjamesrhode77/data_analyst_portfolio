CREATE TABLE IF NOT EXISTS sales_pipeline (
    opportunity_id VARCHAR(20),
    sales_agent VARCHAR(100),
    product VARCHAR(50),
    account VARCHAR(150),
    deal_stage VARCHAR(20),
    engage_date DATE,
    close_date DATE,
    close_value INT
);