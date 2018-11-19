CREATE DATABASE dizziness
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

\connect dizziness

CREATE EXTENSION citext;

CREATE FUNCTION now_utc() RETURNS TIMESTAMP AS $$
  SELECT now() AT TIME ZONE 'utc';
$$ LANGUAGE sql;

CREATE TYPE USERTYPE AS ENUM (
    'patient',
    'physiotherapist',
    'admin'
);

CREATE TYPE SEX AS ENUM (
    'male',
    'female'
);

CREATE TABLE Country (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT NOT NULL
);

CREATE TABLE City (
    id BIGSERIAL PRIMARY KEY,
    country_id BIGINT REFERENCES Country NOT NULL,
    name TEXT NOT NULL,
    zip_code TEXT NOT NULL
);

CREATE TABLE Location (
    id BIGSERIAL PRIMARY KEY,
    city_id BIGINT REFERENCES City NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE UserBase (
    id BIGSERIAL PRIMARY KEY,
    type USERTYPE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email CITEXT NOT NULL UNIQUE,
    password CHAR(60) NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE Patient (
    user_id BIGINT REFERENCES UserBase NOT NULL,
    location_id BIGINT REFERENCES location,
    birth_date DATE,
    sex SEX,
    height SMALLINT,
    weight SMALLINT
);

CREATE TABLE Dizziness (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES UserBase NOT NULL,
    level SMALLINT NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);