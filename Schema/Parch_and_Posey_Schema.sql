CREATE DATABASE parch_and_posey;
USE parch_and_posey;

CREATE TABLE region (
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(50)
);


CREATE TABLE sales_reps (
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region_id INTEGER NOT NULL,
    FOREIGN KEY (region_id) REFERENCES region (id)
);


CREATE TABLE accounts (
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    website VARCHAR(50),
    lat NUMERIC(11 , 8 ),
    lon NUMERIC(11 , 8 ),
    primary_poc VARCHAR(50),
    sales_rep_id INTEGER,
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps (id)
);


CREATE TABLE orders (
    id INTEGER NOT NULL PRIMARY KEY,
    account_id INTEGER,
    occurred_at DATETIME,
    standard_qty INTEGER,
    gloss_qty INTEGER,
    poster_qty INTEGER,
    total INTEGER,
    standard_amt_usd NUMERIC(10 , 2 ),
    gloss_amt_usd NUMERIC(10 , 2 ),
    poster_amt_usd NUMERIC(10 , 2 ),
    total_amt_usd NUMERIC(10 , 2 ),
    FOREIGN KEY (account_id) REFERENCES accounts (id)
);


CREATE TABLE web_events (
    id INTEGER NOT NULL PRIMARY KEY,
    account_id INTEGER,
    occurred_at DATETIME,
    channel VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts (id)
);
