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

CREATE FUNCTION UpdateUpdated() RETURNS TRIGGER 
AS 
$BODY$
BEGIN
    new.updated := now_utc();
    RETURN new;
END;
$BODY$
LANGUAGE plpgsql;

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

CREATE TABLE City (
    zip_code TEXT NOT NULL,
    country_code TEXT REFERENCES Country NOT NULL,
    name TEXT NOT NULL,
    PRIMARY KEY (zip_code, country_code)
);

CREATE TABLE Location (
    id BIGSERIAL PRIMARY KEY,
    zip_code TEXT NOT NULL,
    country_code TEXT NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (zip_code, country_code) REFERENCES City (zip_code, country_code)
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

CREATE TRIGGER UserBaseUpdated BEFORE UPDATE ON UserBase
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

CREATE TABLE Patient (
    user_id BIGINT REFERENCES UserBase NOT NULL PRIMARY KEY,
    phone TEXT,
    birth_date DATE,
    sex SEX,
    height SMALLINT,
    weight SMALLINT,
    zip_code TEXT,
    country_code TEXT,
    address TEXT,
    FOREIGN KEY (zip_code, country_code) REFERENCES City (zip_code, country_code)
);

CREATE TABLE Organisation(
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    zip_code TEXT NOT NULL,
    country_code TEXT NOT NULL,
    address TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    FOREIGN KEY (zip_code, country_code) REFERENCES City (zip_code, country_code)
);

CREATE TRIGGER OrganisationUpdated BEFORE UPDATE ON Organisation
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

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

CREATE TRIGGER RequestUpdated BEFORE UPDATE ON Request
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

CREATE TABLE Period(
    request_id BIGINT REFERENCES Request NOT NULL PRIMARY KEY,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    end_date TIMESTAMP WITH TIME ZONE
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
    custom BOOLEAN NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TRIGGER ExerciseUpdated BEFORE UPDATE ON Exercise
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

CREATE TABLE ExerciseFavorite(
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    UNIQUE(exercise_id, patient_id)
);

CREATE TABLE CustomExercisePatient(
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    UNIQUE(exercise_id, patient_id)
);

CREATE TABLE Dizziness (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    exercise_id BIGINT REFERENCES Exercise,
    level SMALLINT,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TRIGGER DizzinessUpdated BEFORE UPDATE ON Dizziness
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

CREATE TABLE JournalEntry(
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc()
);

CREATE TRIGGER JournalEntryUpdated BEFORE UPDATE ON JournalEntry
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();

CREATE TABLE Recommendation(
    id BIGSERIAL PRIMARY KEY,
    physiotherapist_id BIGINT REFERENCES Physiotherapist NOT NULL,
    exercise_id BIGINT REFERENCES Exercise NOT NULL,
    patient_id BIGINT REFERENCES Patient NOT NULL,
    note TEXT NOT NULL,
    created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now_utc(),
    UNIQUE(physiotherapist_id, exercise_id, patient_id)
);

CREATE TRIGGER RecommendationUpdated BEFORE UPDATE ON Recommendation
FOR EACH ROW EXECUTE PROCEDURE UpdateUpdated();