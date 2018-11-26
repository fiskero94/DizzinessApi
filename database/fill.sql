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

INSERT INTO Dizziness (user_id, level, note) VALUES (1, 7, 'Jeg er ret svimmel');
INSERT INTO Dizziness (user_id, level, note) VALUES (2, 8, 'Meget svimmel i dag');
INSERT INTO Dizziness (user_id, level, note) VALUES (2, 6, 'Ikke så svimmel denne uge');
INSERT INTO Dizziness (user_id, level, note) VALUES (3, 9, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (4, 5, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (4, 8, 'Rigtig svimmel');
INSERT INTO Dizziness (user_id, level, note) VALUES (5, 9, 'Værre i dag');

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

INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (4, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (2, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (2, 2);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (3, 3);

INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (1, 1);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (2, 1);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (3, 2);
INSERT INTO CustomExercisePatient(exercise_id, patient_id) VALUES (4, 3);

INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (6, 1, 1, 'This exercise will be good for you');   
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (6, 2, 1, 'This should fit for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (7, 3, 2, 'My custom exercise for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (7, 4, 3, 'This should do the trick');