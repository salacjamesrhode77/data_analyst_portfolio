CREATE TABLE IF NOT EXISTS accounts (
    account VARCHAR(100),
    sector VARCHAR(50),
    year_established INT,
    revenue NUMERIC(15,2),
    employees INT,
    office_location VARCHAR(50),
    subsidiary_of VARCHAR(100)
);
