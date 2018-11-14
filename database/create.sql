CREATE DATABASE dizziness
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

\connect dizziness

CREATE FUNCTION now_utc() RETURNS TIMESTAMP AS $$
  SELECT now() AT TIME ZONE 'utc';
$$ LANGUAGE sql;

CREATE TABLE dizziness (
    id SERIAL PRIMARY KEY,
    level SMALLINT NOT NULL,
    note VARCHAR(1024) NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);