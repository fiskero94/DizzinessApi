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
    'physiotherapist'
);

CREATE TYPE SEX AS ENUM (
    'male',
    'female'
);

CREATE TABLE Country (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE ZipCode (
    zip_code TEXT PRIMARY KEY,
    country_code TEXT REFERENCES Country NOT NULL,
    city_name TEXT NOT NULL
);

CREATE TABLE Location (
    id BIGSERIAL PRIMARY KEY,
    zip_code TEXT REFERENCES ZipCode NOT NULL,
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
    user_id BIGINT REFERENCES UserBase NOT NULL PRIMARY KEY,
    location_id BIGINT REFERENCES location,
    phone TEXT,
    birth_date DATE,
    sex SEX,
    height SMALLINT,
    weight SMALLINT
);

CREATE TABLE Dizziness (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES UserBase NOT NULL,
    exercise_id BIGINT REFERENCES Exercise,
    level SMALLINT NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE Organisation(
    id BIGSERIAL PRIMARY KEY,
    location_id BIGINT REFERENCES location,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE Physiotherapist (
    user_id BIGINT REFERENCES UserBase NOT NULL PRIMARY KEY,
    organisation_id BIGINT REFERENCES Organisation NOT NULL 
);

CREATE TABLE Request(
    id BIGSERIAL PRIMARY KEY,
    physiotherapist_id BIGINT REFERENCES Physiotherapist NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    accepted BOOLEAN NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE Period(
    request_id BIGINT REFERENCES Request NOT NULL PRIMARY KEY,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    end_date TIMESTAMP WITH TIME ZONE
);

CREATE TABLE JournalEntry(
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE StepCount(
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    count INT NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE Exercise(
    id BIGSERIAL PRIMARY KEY,
    author_id BIGINT REFERENCES Physiotherapist,
    name TEXT NOT NULL,
    description TEXT,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    custom BOOLEAN NOT NULL
);

CREATE TABLE ExerciseFeedback(
    id BIGSERIAL PRIMARY KEY,
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    dizziness_id BIGINT REFERENCES Dizziness NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    dizziness_given BOOLEAN NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TABLE ExerciseFavorite(
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL
);

CREATE TABLE CustomExercisePatient(
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL
);

CREATE TABLE Recommendation(
    id BIGSERIAL PRIMARY KEY,
    physiotherapist_id BIGINT REFERENCES Physiotherapist NOT NULL,
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);