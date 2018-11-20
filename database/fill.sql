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

INSERT INTO City (country_id, name) VALUES ('1', 'Kobenhavn');
INSERT INTO City (country_id, name) VALUES ('1', 'Aalborg');
INSERT INTO City (country_id, name) VALUES ('1', 'Aarhus');
INSERT INTO City (country_id, name) VALUES ('1', 'Odense');
INSERT INTO City (country_id, name) VALUES ('1', 'Skive');
INSERT INTO City (country_id, name) VALUES ('1', 'Viborg');
INSERT INTO City (country_id, name) VALUES ('1', 'Randers');
INSERT INTO City (country_id, name) VALUES ('1', 'Vejle');
INSERT INTO City (country_id, name) VALUES ('2', 'Torshavn');
INSERT INTO City (country_id, name) VALUES ('3', 'Santa Domingo');
INSERT INTO City (country_id, name) VALUES ('4', 'Cairo');
INSERT INTO City (country_id, name) VALUES ('5', 'Helsinki');
INSERT INTO City (country_id, name) VALUES ('6', 'Paris');
INSERT INTO City (country_id, name) VALUES ('7', 'Berlin');
INSERT INTO City (country_id, name) VALUES ('8', 'Athens');
INSERT INTO City (country_id, name) VALUES ('9', 'Budapest');
INSERT INTO City (country_id, name) VALUES ('10', 'Reykjavik');
INSERT INTO City (country_id, name) VALUES ('11', 'Tokyo');

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

INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Hans', 'Petersen', 'hanspetersen@gmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('physiotherapist', 'Peter', 'Hansen', 'peterhansen@gmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Anna', 'Larsen', 'annalarsen@hotmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Kristian Magnus', 'Larsen', 'krimaglar@hotmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Johannes', 'Pedersen', 'johannestheman@gmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Amalie', 'Olsen', 'aolsen@hotmail.com');
INSERT INTO UserBase (type, first_name, last_name, email, password) VALUES ('patient', 'Fie', 'Nielsen', 'nielsenfie@hotmail.com');

INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (3, 3, 1957-03-05, 'female', 165, 60);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (4, 4, 1943-11-08, 'male', 175, 91);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (5, 5, 1961-09-18, 'male', 190, 110);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (6, 6, 1955-04-30, 'female', 170, 59);
INSERT INTO Patient (user_id, location_id, birth_date, sex, height, weight) VALUES (7, 7, 1970-08-17, 'female', 177, 68);

INSERT INTO Dizziness (user_id, level, note) VALUES (1, 7, 'Jeg er ret svimmel');
INSERT INTO Dizziness (user_id, level, note) VALUES (2, 8, 'Meget svimmel i dag');
INSERT INTO Dizziness (user_id, level, note) VALUES (2, 6, 'Ikke så svimmel denne uge');
INSERT INTO Dizziness (user_id, level, note) VALUES (3, 9, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (4, 5, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (5, 7, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (6, 7, '');
INSERT INTO Dizziness (user_id, level, note) VALUES (7, 8, 'Rigtig svimmel');
INSERT INTO Dizziness (user_id, level, note) VALUES (7, 9, 'Værre i dag');

INSERT INTO Department(location_id, name, phone) VALUES (1, 'Department Navn 1', 59285722);
INSERT INTO Department(location_id, name, phone) VALUES (1, 'Department Navn 2', 52958354);

INSERT INTO Physiotherapist (user_id, location_id, birth_date, sex, height, weight) VALUES (1, 1, 1973-02-25, 'male', 181, 74);
INSERT INTO Physiotherapist (user_id, location_id, birth_date, sex, height, weight) VALUES (2, 2, 1965-08-11, 'male', 184, 85);

INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (1, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (1, 2, true);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (2, 1, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (2, 2, false);
INSERT INTO Request(physiotherapist_id, patient_id, accepted) VALUES (2, 3, true);

INSERT INTO Period(request_id) VALUES (1);
INSERT INTO Period(request_id) VALUES (2);
INSERT INTO Period(request_id) VALUES (3);
INSERT INTO Period(request_id) VALUES (4);
INSERT INTO Period(request_id) VALUES (5);

INSERT INTO JournalEntry(patient_id, note) VALUES (1, ''); //what write here
INSERT INTO JournalEntry(patient_id, note) VALUES (1, '');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, '');
INSERT INTO JournalEntry(patient_id, note) VALUES (1, '');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, '');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, '');
INSERT INTO JournalEntry(patient_id, note) VALUES (2, '');

INSERT INTO StepCount(patient_id, count, date) VALUES (1, 400);
INSERT INTO StepCount(patient_id, count, date) VALUES (1, 809);
INSERT INTO StepCount(patient_id, count, date) VALUES (2, 643);
INSERT INTO StepCount(patient_id, count, date) VALUES (2, 728);
INSERT INTO StepCount(patient_id, count, date) VALUES (3, 570);

INSERT INTO Exercise(author_id, name, description) VALUES (1, 'Lunges');
INSERT INTO Exercise(author_id, name, description) VALUES (1, 'Squats');
INSERT INTO Exercise(author_id, name, description) VALUES (2, 'Raise Shoulders');
INSERT INTO Exercise(author_id, name, description) VALUES (2, 'Turn Head');

INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 1, 1, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 2, 2, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 3, 2, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (1, 4, 3, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 5, 4, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 6, 5, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (3, 7, 6, false);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (2, 8, 7, true);
INSERT INTO ExerciseFeedback(exercise_id, dizziness_id, patient_id, dizziness_given) VALUES (3, 9, 7, true);

INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (4, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (2, 1);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (2, 2);
INSERT INTO ExerciseFavorite(exercise_id, patient_id) VALUES (3, 3);

INSERT INTO CustomExercise(author_id, name, description) VALUES (1, 'Touch toes', 'Bend down and try to touch your toes');
INSERT INTO CustomExercise(author_id, name, description) VALUES (1, 'Look at ceiling and floor', 'First look at the ceiling and then at the floor and repeat');

INSERT INTO CustomExercisePatient(custom_exercise_id, patient_id) VALUES (1, 1);
INSERT INTO CustomExercisePatient(custom_exercise_id, patient_id) VALUES (1, 1);
INSERT INTO CustomExercisePatient(custom_exercise_id, patient_id) VALUES (2, 2);
INSERT INTO CustomExercisePatient(custom_exercise_id, patient_id) VALUES (2, 3);

INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (1, 1, 1, 'This exercise will be good for you');   
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (1, 2, 1, 'This should fit for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (2, 3, 2, 'My custom exercise for you');
INSERT INTO Recommendation(physiotherapist_id, exercise_id, patient_id, note) VALUES (2, 4, 3, 'This should do the trick');