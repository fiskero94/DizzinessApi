\connect postgres
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'dizziness';
REVOKE CONNECT ON DATABASE dizziness FROM public;
DROP DATABASE dizziness;

UPDATE pg_database SET datistemplate = 'false' WHERE datname = 'dizzinessbase';
DROP DATABASE dizzinessbase;

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
    description TEXT NOT NULL,
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

\connect dizziness

INSERT INTO Country (code, name) VALUES ('DK', 'Denmark');
INSERT INTO Country (code, name) VALUES ('FO', 'Faroe Islands');
INSERT INTO Country (code, name) VALUES ('DO', 'Dominican Republic');
INSERT INTO Country (code, name) VALUES ('EG', 'Egypt');
INSERT INTO Country (code, name) VALUES ('FI', 'Finland');
INSERT INTO Country (code, name) VALUES ('FR', 'France');
INSERT INTO Country (code, name) VALUES ('DE', 'Germany');
INSERT INTO Country (code, name) VALUES ('GR', 'Greece');
INSERT INTO Country (code, name) VALUES ('HU', 'Hungary');
INSERT INTO Country (code, name) VALUES ('IS', 'Iceland');
INSERT INTO Country (code, name) VALUES ('JP', 'Japan');

INSERT INTO City (zip_code, country_code, name) VALUES ('1000', 'DK', 'Kobenhavn');
INSERT INTO City (zip_code, country_code, name) VALUES ('9000', 'DK', 'Aalborg');
INSERT INTO City (zip_code, country_code, name) VALUES ('8000', 'DK', 'Aarhus');
INSERT INTO City (zip_code, country_code, name) VALUES ('5000', 'DK', 'Odense');
INSERT INTO City (zip_code, country_code, name) VALUES ('7800', 'DK', 'Skive');
INSERT INTO City (zip_code, country_code, name) VALUES ('8800', 'DK', 'Viborg');
INSERT INTO City (zip_code, country_code, name) VALUES ('8900', 'DK', 'Randers');
INSERT INTO City (zip_code, country_code, name) VALUES ('7100', 'DK', 'Vejle');
INSERT INTO City (zip_code, country_code, name) VALUES ('1', 'FO', 'Torshavn');
INSERT INTO City (zip_code, country_code, name) VALUES ('2', 'DO', 'Santa Domingo');
INSERT INTO City (zip_code, country_code, name) VALUES ('3', 'EG', 'Cairo');
INSERT INTO City (zip_code, country_code, name) VALUES ('4', 'FI', 'Helsinki');
INSERT INTO City (zip_code, country_code, name) VALUES ('5', 'FR', 'Paris');
INSERT INTO City (zip_code, country_code, name) VALUES ('6', 'DE', 'Berlin');
INSERT INTO City (zip_code, country_code, name) VALUES ('7', 'GR', 'Athens');
INSERT INTO City (zip_code, country_code, name) VALUES ('8', 'HU', 'Budapest');
INSERT INTO City (zip_code, country_code, name) VALUES ('9', 'IS', 'Reykjavik');
INSERT INTO City (zip_code, country_code, name) VALUES ('10', 'JP', 'Tokyo');

INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Anna', 'Larsen', 'annalarsen@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Kristian Magnus', 'Larsen', 'krimaglar@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Johannes', 'Pedersen', 'johannestheman@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Amalie', 'Olsen', 'aolsen@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Fie', 'Nielsen', 'nielsenfie@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');

INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Hans', 'Petersen', 'hanspetersen@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Peter', 'Hansen', 'peterhansen@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');

INSERT INTO Patient (user_id, phone, birth_date, sex, height, weight, zip_code, country_code, address) VALUES (1, '26713312', '1957-03-05', 'female', 165, 60, '1000', 'DK', 'Mitchellsgade 8');
INSERT INTO Patient (user_id, phone, birth_date, sex, height, weight, zip_code, country_code, address) VALUES (2, '12345678', '1943-11-08', 'male', 175, 91, '1000', 'DK', 'Ribevej 3');
INSERT INTO Patient (user_id, phone, birth_date, sex, height, weight, zip_code, country_code, address) VALUES (3, '72363523', '1961-09-18', 'male', 190, 110, '1000', 'DK', 'Nordogade 11');
INSERT INTO Patient (user_id, phone, birth_date, sex, height, weight, zip_code, country_code, address) VALUES (4, '32634253', '1955-04-30', 'female', 170, 59, '1000', 'DK', 'Hjortebjergvej 1');
INSERT INTO Patient (user_id, phone, birth_date, sex, height, weight, zip_code, country_code, address) VALUES (5, '33252362', '1970-08-17', 'female', 177, 68, '1000', 'DK', 'Adalsvej 22');

INSERT INTO Organisation(name, phone, zip_code, country_code, address) VALUES ('Organisation Navn 1', 59285722, '1000', 'DK', 'Liseborgvej 27');
INSERT INTO Organisation(name, phone, zip_code, country_code, address) VALUES ('Organisation Navn 2', 52958354, '1000', 'DK', 'Kristrup Engvej 34');

INSERT INTO Physiotherapist (user_id, organisation_id) VALUES (6, 1);
INSERT INTO Physiotherapist (user_id, organisation_id) VALUES (7, 2);

INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 2, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 2, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 3, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 3, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 4, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 5, true);

INSERT INTO Period(request_id) VALUES (2);
INSERT INTO Period(request_id) VALUES (5);
INSERT INTO Period(request_id) VALUES (6);
INSERT INTO Period(request_id) VALUES (7);
INSERT INTO Period(request_id) VALUES (8);

INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Det gik godt', '2018-11-21 14:42:22');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Jeg har det lidt bedre', '2018-11-22 15:43:23');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'I dag har jeg det ikke så godt', '2018-11-23 16:44:24');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Værre i dag', '2018-10-14 14:42:22');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Aliquam erat volutpat. Duis tempor orci vitae diam tempor, sit amet convallis felis congue. Nullam id sapien dapibus, dapibus dolor.', '2018-10-15 09:33:57');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Integer hendrerit enim vitae nunc euismod vestibulum. Phasellus lobortis purus in nulla convallis convallis. Ut eu arcu ut libero lobortis.', '2018-10-15 11:55:56');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Aenean accumsan finibus suscipit. Morbi velit nisi, molestie non tincidunt eu, consequat in nibh. Nullam pretium lectus at convallis sollicitudin.', '2018-10-15 13:17:48');
INSERT INTO JournalEntry(patient_id, note, created) VALUES (1, 'Morbi eget faucibus risus. Duis nec sollicitudin leo. Suspendisse potenti. Phasellus et arcu non ligula gravida fermentum vitae id nulla.', '2018-10-15 17:28:32');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'Bedre');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'Meget godt');

INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7484, '2018-10-15');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5715, '2018-10-16');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5487, '2018-10-17');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6183, '2018-10-18');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6788, '2018-10-19');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 4406, '2018-10-20');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5488, '2018-10-21');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5880, '2018-10-22');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 4066, '2018-10-23');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6373, '2018-10-24');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7397, '2018-10-25');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6881, '2018-10-26');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6329, '2018-10-27');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6173, '2018-10-28');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5923, '2018-10-29');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5553, '2018-10-30');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6912, '2018-10-31');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7554, '2018-11-01');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 4501, '2018-11-02');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7349, '2018-11-03');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5874, '2018-11-04');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6042, '2018-11-05');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7339, '2018-11-06');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6541, '2018-11-07');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5677, '2018-11-08');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 4950, '2018-11-09');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7388, '2018-11-10');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6767, '2018-11-11');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5437, '2018-11-12');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7733, '2018-11-13');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6125, '2018-11-14');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5178, '2018-11-15');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6670, '2018-11-16');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7053, '2018-11-17');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7087, '2018-11-18');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5751, '2018-11-19');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6504, '2018-11-21');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7335, '2018-11-22');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5963, '2018-11-23');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5980, '2018-11-24');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 5853, '2018-11-25');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 6077, '2018-11-26');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 7437, '2018-11-27');
INSERT INTO StepCount(patient_id, count, date) VALUES (2, 643, '2018-11-11');
INSERT INTO StepCount(patient_id, count, date) VALUES (2, 728, '2018-11-12');
INSERT INTO StepCount(patient_id, count, date) VALUES (3, 570, '2018-12-15');

INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Lunges', '', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Squats', 'Squat down to a 90 degree angle and then up again', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (7, 'Raise Shoulders', 'Raise your shoulders up and down and repeat', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (7, 'Turn Head', 'Look to your left and then your right and repeat', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (7, 'Touch Toes', 'Bend down and touch your toes and up again and repeat', true);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (7, 'Jumping Jacks without arms', 'Do standard jumping jack but without moving your arms', true);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Genopret 1', 'Trin 1: Sid i en komfortabel position. Fokuser på et punkt i øjenhøjde med hovedet let foroverbøjet (ca. 20-30 grader). \n\nTrin 2: Fortsæt med at fokusere på punktet, mens du bevæger hovedet fra side til side. Husk at fokusere på punktet med øjnene, mens du bevæger hovedet!', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Genopret 2', 'Trin 1: Sid i en komfortabel position. Fokuser på et punkt i øjenhøjde med hovedet let foroverbøjet (ca. 20-30 grader). \n\nTrin 2: Hovedet skal bevæges til højre og venstre side, men i tilfældig rækkefølge. Bevæg hovedet til hver side ca. 10-20 gange. Bevægelserne skal være med forskellig hastighed. \n\nHold hovedet i yderpositionen i et par sekunder, før du vender tilbage til startpositionen. \n\nHusk at fokusere på punktet med øjnene, mens du bevæger hovedet!', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Genopret 3', 'Trin 1: Sid eller stå behageligt. \n\nTrin 2: Find 5 punkter (genstande) i rummet, en i midten, til højre, til venstre, i loftet og i gulvet. \n\nTrin 3: Bevæg hovedet for at se på de forskellige genstande du har udvalgt. Først i ordnet rækkefølge, derefter i vilkårlig rækkefølge. \n\nTrin 3: Gentag trin 1-2, hvor du får en hjælper til at sige, hvilken genstand du skal se på. \n\nTrin 4: Gentag Trin 2 og 3 gentagne gange (ca. 20 gange) 3 gange dagligt.', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Genopret 4', 'Trin 1: Sid eller stå behageligt. Trin 2: Hold kroppen stille. Fokuser på et punkt, ca. en meter foran dig. Drej hovedet hurtigt (max 45 gr.) mod højre og hold hele tiden fokus mod punktet foran dig - Vent i 3 sek.. Drej hovedet tilbage til udgangsposition. Vent i 3 sek. Drej hovedet hurtigt (max 45 gr.) mod venstre og hold hele tiden fokus mod punktet foran dig - Vent i 3 sekunder. Drej hovedet tilbage til udgangsposition. \n\nTrin 3: Gentag trin 1-2, men denne gang med hovedet drejet 45 gr. mod højre. Fokuser på punktet foran dig. Prøv herefter at bevæge hovedet op og ned. \n\nTrin 4: Gentag Trin 2 og 3 gentagne gange (ca. 20 gange) 3 gange dagligt.', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Erstat 1', 'Trin 1: Start med at stå med ryggen tæt på en væg med benene let spredte. \n\nTrin 2: Kryds det højre ben ind foran det venstre. Hold benet krydset i luften i 5 sekunder og før det tilbage til udgangspositionen. \n\nTrin 3: Gentag denne bevægelse med det venstre ben. \n\nTrin 4: Gentag Trin 1-3 ca. 20 gange, 3 gange dagligt.', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Erstat 2', 'Trin 1: Start med at stå foran en væg med fødderne pegende fremad mod væggen. \n\nTrin 2: Bevæg dig langs væggen med sideskridt mod den ene ende og herefter den anden. \n\nTrin 3: Gentag øvelsen med lukkede øjne. \n\nTrin 4: Gentag trin 2 og 3 ca. 20 gange, 3 gange dagligt.', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Erstat 3', 'Trin 1: Start med at stå foran en væg med fødderne pegende fremad mod væggen. \n\nTrin 2: Begynd at bevæge dig langs væggen ved at dreje dig 360 grader rundt igen og igen til du når den ene ende af væggen. Herefter ”ruller” du den anden vej, til du når den modsatte ende af væggen. \n\nTrin 3: Gentag øvelsen med lukkede øjne \n\nTrin 4: Gentag trin 2 og 3 ca. 20 gange.', false);
INSERT INTO Exercise(author_id, name, description, custom) VALUES (6, 'Erstat 4', 'Trin 1: Start med at stå med siden til, tæt på en væg med benene let spredte. \n\nTrin 2: Gå tå-gang ligeud (a), diagonalt (b) og i en bue (c) mod den anden ende af væggen. \n\nTrin 3: Gå hæl-gang ligeud, diagonalt og i en bue mod den anden ende af væggen. \n\nTrin 4: Gentag trin 2 og 3 ca. 20 gange.', false);

INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 8, 4, 'Nunc vel augue vel orci faucibus pharetra a quis augue. Aenean dictum enim eu nulla blandit varius. In ut tristique.', '2018-10-15 12:42:23');
INSERT INTO Dizziness (patient_id, level, note, created) VALUES (1, 6, 'Etiam dapibus, tellus eget consequat bibendum, ante metus eleifend orci, quis tristique nibh urna molestie lacus. Nulla condimentum ante eu.', '2018-10-15 14:57:43');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 13, 3, 'In at velit facilisis urna rhoncus accumsan in tristique mauris. Etiam finibus ultricies feugiat. Aenean eu tincidunt nibh. Etiam semper.', '2018-10-15 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, note) VALUES (1, 2, 'No level');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 5, 'Graphdata', '2018-10-16 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 7, 'Graphdata', '2018-10-17 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 4, 'Graphdata', '2018-10-20 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 3, 'Graphdata', '2018-10-21 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 7, 'Graphdata', '2018-10-23 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 8, 'Graphdata', '2018-10-24 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 5, 'Graphdata', '2018-10-25 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 6, 'Graphdata', '2018-10-26 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 4, 'Graphdata', '2018-10-28 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 3, 'Graphdata', '2018-11-01 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 6, 'Graphdata', '2018-11-02 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 6, 'Graphdata', '2018-11-14 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 6, 'Graphdata', '2018-11-15 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 5, 'Graphdata', '2018-11-16 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 4, 'Graphdata', '2018-11-17 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 2, 'Graphdata', '2018-11-18 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 5, 'Graphdata', '2018-11-24 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 6, 'Graphdata', '2018-11-25 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 7, 'Graphdata', '2018-11-26 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note, created) VALUES (1, 2, 4, 'Graphdata', '2018-11-27 18:23:47');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (2, 2, 8, 'Meget svimmel i dag');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (2, 4, 6, 'Ikke så svimmel denne uge');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (3, 3, 9, '');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (4, 3, 5, '');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (4, 5, 8, 'Rigtig svimmel');
INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (5, 2, 9, 'Værre i dag');

INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (3, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (4, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (2, 2);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (3, 3);

INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (5, 1);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (6, 1);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (6, 2);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (5, 3);

INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (6, 1, 1, 'This exercise will be good for you');   
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (6, 2, 1, 'This should fit for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (7, 3, 2, 'My custom exercise for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (7, 4, 3, 'This should do the trick');

CREATE DATABASE dizzinessbase TEMPLATE dizziness;
ALTER DATABASE dizzinessbase CONNECTION LIMIT 0;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'dizzinessbase';
UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'dizzinessbase';