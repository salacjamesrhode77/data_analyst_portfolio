-- Switch to database
USE DATABASE ECOMM_DB;
USE SCHEMA ECOMM;

COPY INTO PARQUET_ORDERS
FROM (
    SELECT
        $1:"address_city"::VARCHAR,
        $1:"address_company"::VARCHAR,
        $1:"address_province"::VARCHAR,
        $1:"address_zip"::INT,
        $1:"billing_name"::VARCHAR,
        $1:"email"::VARCHAR,
        $1:"first_name"::VARCHAR,
        $1:"fulfillment_date"::VARCHAR,
        $1:"image_src"::VARCHAR,
        $1:"last_name"::VARCHAR,
        $1:"lineitem_name"::VARCHAR,
        $1:"lineitem_qty"::INT,
        $1:"order_date"::VARCHAR,
        $1:"order_number"::VARCHAR,
        $1:"payment_date"::VARCHAR,
        $1:"payment_method"::VARCHAR,
        $1:"payment_reference"::VARCHAR,
        $1:"phone"::VARCHAR,
        $1:"product_category"::VARCHAR,
        $1:"product_description"::VARCHAR,
        $1:"product_sku"::VARCHAR,
        $1:"unit_price"::FLOAT,
        $1:"vendor"::VARCHAR
    FROM @PARQUET_STAGE/from_faker
)
FILE_FORMAT = 'MY_PARQUET_FORMAT';
