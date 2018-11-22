INSERT INTO Country (name, code) VALUES ('Denmark', 'DK');
INSERT INTO Country (name, code) VALUES ('Faroe Islands', 'FO');
INSERT INTO Country (name, code) VALUES ('Dominican Republic', 'DO');
INSERT INTO Country (name, code) VALUES ('Egypt', 'EG');
INSERT INTO Country (name, code) VALUES ('Finland', 'FI');
INSERT INTO Country (name, code) VALUES ('France', 'FR');
INSERT INTO Country (name, code) VALUES ('Germany', 'DE');
INSERT INTO Country (name, code) VALUES ('Greece', 'GR');
INSERT INTO Country (name, code) VALUES ('Hungary', 'HU');
INSERT INTO Country (name, code) VALUES ('Iceland', 'IS');
INSERT INTO Country (name, code) VALUES ('Japan', 'JP');

INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Kobenhavn', '1000');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Aalborg', '9000');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Aarhus', '8000');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Odense', '5000');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Skive', '7800');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Viborg', '8800');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Randers', '8900');
INSERT INTO City (country_id, name, zip_code) VALUES ('1', 'Vejle', '7100');
INSERT INTO City (country_id, name, zip_code) VALUES ('2', 'Torshavn', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('3', 'Santa Domingo', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('4', 'Cairo', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('5', 'Helsinki', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('6', 'Paris', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('7', 'Berlin', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('8', 'Athens', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('9', 'Budapest', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('10', 'Reykjavik', '');
INSERT INTO City (country_id, name, zip_code) VALUES ('11', 'Tokyo', '');

INSERT INTO Location (city_id, address) VALUES (1, 'Mitchellsgade 8');  
INSERT INTO Location (city_id, address) VALUES (1, 'Ribevej 3');
INSERT INTO Location (city_id, address) VALUES (1, 'Nordogade 11');
INSERT INTO Location (city_id, address) VALUES (1, 'Hjortebjergvej 1');
INSERT INTO Location (city_id, address) VALUES (1, 'Adalsvej 22');
INSERT INTO Location (city_id, address) VALUES (1, 'Liseborgvej 27');
INSERT INTO Location (city_id, address) VALUES (1, 'Kristrup Engvej 34');
INSERT INTO Location (city_id, address) VALUES (1, 'Fidalvej 6');
INSERT INTO Location (city_id, address) VALUES (2, 'Baraldsgota 53');
INSERT INTO Location (city_id, address) VALUES (3, 'Calle Duarte 76');
INSERT INTO Location (city_id, address) VALUES (4, '3 Khaled Ibn El Walid');
INSERT INTO Location (city_id, address) VALUES (5, 'Kaarrostie 56');
INSERT INTO Location (city_id, address) VALUES (6, '95  Place de la Madeleine');
INSERT INTO Location (city_id, address) VALUES (7, 'Genslerstrase 84');
INSERT INTO Location (city_id, address) VALUES (8, 'Greekadresse 43');
INSERT INTO Location (city_id, address) VALUES (9, 'Arpad fejedelem utja 16');
INSERT INTO Location (city_id, address) VALUES (10, 'Laugarvegur 95');
INSERT INTO Location (city_id, address) VALUES (11, 'Konichiwa 23');

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

INSERT INTO Department(location_id, name, phone) VALUES (1, 'Department Navn 1', 59285722);
INSERT INTO Department(location_id, name, phone) VALUES (2, 'Department Navn 2', 52958354);

INSERT INTO Physiotherapist (user_id, department_id) VALUES (6, 1);
INSERT INTO Physiotherapist (user_id, department_id) VALUES (7, 2);

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

INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 1, 1, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 2, 2, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 3, 2, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 4, 3, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 5, 4, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 6, 5, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (3, 7, 5, false);


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