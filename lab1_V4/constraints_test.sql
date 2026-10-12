INSERT INTO users (full_name, email, password_hash) VALUES
('Test User', 'ivan.petrov@mail.com', 'hash6');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Invalid Movie', 2020, -50, 7.0, 1);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(2, 2, 15, 'Rating too high');

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(1, 'basic', '2026-05-01', '2026-04-01', 299.00);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(1, 1, 5, 'Duplicate review for the same movie');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Movie without genre', 2020, 100, 7.0, 999);

INSERT INTO users (full_name, email, password_hash) VALUES
('User without email', NULL, 'hash7');

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(2, 'vip', '2026-05-01', '2026-06-01', 999.00);