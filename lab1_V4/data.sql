INSERT INTO subscriptions (plan_type, price) VALUES
('basic', 299.99), ('standard', 599.99), ('premium', 999.99);

INSERT INTO genres (name) VALUES
('Drama'),
('Comedy'),
('Sci-Fi'),
('Thriller'),
('Animation');

INSERT INTO users (full_name, email, password_hash, birth_date) VALUES
('Ivan Petrov', 'ivan.petrov@mail.com', 'hash1', '1995-03-12'),
('Maria Smirnova', 'maria.smirnova@mail.com', 'hash2', '1998-07-22'),
('Alexey Kuznetsov', 'alex.kuznetsov@mail.com', 'hash3', '2000-01-05'),
('Olga Volkova', 'olga.volkova@mail.com', 'hash4', '1992-11-30'),
('Dmitry Sokolov', 'dmitry.sokolov@mail.com', 'hash5', '1997-05-18');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Star Trek', 2019, 135, 8.2, 3),
('Laughter Through Tears', 2020, 102, 7.1, 2),
('Dark Side', 2018, 118, 8.9, 4),
('Simple Story', 2021, 95, 6.8, 1),
('Space Flight', 2022, 140, 9.0, 3),
('Cat''s Adventures', 2017, 80, 7.5, 5),
('Night Watch', 2016, 110, 7.9, 4),
('Summer Rain', 2023, 99, 6.5, 1);

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(1, 'basic', '2026-01-01', '2026-02-01', 299.00),
(2, 'premium', '2026-02-15', '2026-03-15', 799.00),
(3, 'standard', '2026-03-01', '2026-04-01', 499.00),
(4, 'basic', '2026-01-10', '2026-02-10', 299.00),
(5, 'premium', '2026-04-01', '2026-05-01', 799.00);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(1, 1, 9, 'Liked it very much'),
(2, 1, 7, 'Not bad, but dragged'),
(3, 3, 10, 'Best thriller of the year'),
(4, 5, 8, 'Great graphics'),
(5, 6, 6, 'Average');

INSERT INTO viewing_history (user_id, movie_id, progress_percent) VALUES
(1, 1, 100),
(1, 2, 45),
(2, 3, 100),
(3, 5, 80),
(4, 6, 30),
(5, 7, 100);