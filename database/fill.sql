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

INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('1000', 'DK', 'Kobenhavn');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('9000', 'DK', 'Aalborg');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('8000', 'DK', 'Aarhus');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('5000', 'DK', 'Odense');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('7800', 'DK', 'Skive');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('8800', 'DK', 'Viborg');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('8900', 'DK', 'Randers');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('7100', 'DK', 'Vejle');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('1', 'FO', 'Torshavn');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('2', 'DO', 'Santa Domingo');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('3', 'EG', 'Cairo');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('4', 'FI', 'Helsinki');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('5', 'FR', 'Paris');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('6', 'DE', 'Berlin');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('7', 'GR', 'Athens');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('8', 'HU', 'Budapest');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('9', 'IS', 'Reykjavik');
INSERT INTO ZipCode (zip_code, country_code, city_name) VALUES ('10', 'JP', 'Tokyo');

INSERT INTO Location (zip_code, address) VALUES ('1000', 'Mitchellsgade 8');  
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Ribevej 3');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Nordogade 11');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Hjortebjergvej 1');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Adalsvej 22');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Liseborgvej 27');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Kristrup Engvej 34');
INSERT INTO Location (zip_code, address) VALUES ('1000', 'Fidalvej 6');
INSERT INTO Location (zip_code, address) VALUES ('9000', 'Baraldsgota 53');
INSERT INTO Location (zip_code, address) VALUES ('8000', 'Calle Duarte 76');
INSERT INTO Location (zip_code, address) VALUES ('5000', '3 Khaled Ibn El Walid');
INSERT INTO Location (zip_code, address) VALUES ('7800', 'Kaarrostie 56');
INSERT INTO Location (zip_code, address) VALUES ('8800', '95  Place de la Madeleine');
INSERT INTO Location (zip_code, address) VALUES ('8900', 'Genslerstrase 84');
INSERT INTO Location (zip_code, address) VALUES ('7100', 'Greekadresse 43');
INSERT INTO Location (zip_code, address) VALUES ('1', 'Arpad fejedelem utja 16');
INSERT INTO Location (zip_code, address) VALUES ('2', 'Laugarvegur 95');
INSERT INTO Location (zip_code, address) VALUES ('3', 'Konichiwa 23');

INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Anna', 'Larsen', 'annalarsen@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Kristian Magnus', 'Larsen', 'krimaglar@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Johannes', 'Pedersen', 'johannestheman@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Amalie', 'Olsen', 'aolsen@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Fie', 'Nielsen', 'nielsenfie@hotmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');

INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Hans', 'Petersen', 'hanspetersen@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Peter', 'Hansen', 'peterhansen@gmail.com', '$2b$10$2Sq9Kwqwwt5KLVKEebKyrOtd5REbkxHpB19N/3gNejlgPoLXI2DDe');

INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (1, 1, '1957-03-05', 'female', 165, 60);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (2, 2, '1943-11-08', 'male', 175, 91);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (3, 3, '1961-09-18', 'male', 190, 110);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (4, 4, '1955-04-30', 'female', 170, 59);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (5, 5, '1970-08-17', 'female', 177, 68);

INSERT INTO Organisation(location_id, name, phone) VALUES (1, 'Organisation Navn 1', 59285722);
INSERT INTO Organisation(location_id, name, phone) VALUES (2, 'Organisation Navn 2', 52958354);

INSERT INTO Physiotherapist (user_id, organisation_id) VALUES (6, 1);
INSERT INTO Physiotherapist (user_id, organisation_id) VALUES (7, 2);

INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (6, 2, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 2, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (7, 3, true);

INSERT INTO Period(request_id) VALUES (1);
INSERT INTO Period(request_id) VALUES (2);
INSERT INTO Period(request_id) VALUES (3);
INSERT INTO Period(request_id) VALUES (4);
INSERT INTO Period(request_id) VALUES (5);

INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'Det gik godt');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'Jeg har det lidt bedre');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'I dag har jeg det ikke så godt');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, 'Værre i dag');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, 'Ikke så godt');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, 'Bedre');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, 'Meget godt');

INSERT INTO StepCount(patient_id, count, date) VALUES (1, 400, '2018-11-05');
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 809, '2018-11-06');
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

INSERT INTO Dizziness (patient_id, exercise_id, level, note) VALUES (1, 1, 7, 'Jeg er ret svimmel');
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