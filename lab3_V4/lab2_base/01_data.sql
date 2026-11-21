WITH v(email, title, watched_at) AS (
    VALUES
    ('ivan.petrov@mail.com', 'Star Trek', '2026-01-05 20:00:00'),
    ('ivan.petrov@mail.com', 'Laughter Through Tears', '2026-02-14 19:30:00'),
    ('maria.smirnova@mail.com', 'Dark Side', '2026-02-20 21:00:00'),
    ('alex.kuznetsov@mail.com', 'Space Flight', '2026-03-12 20:30:00'),
    ('olga.volkova@mail.com', 'Cat''s Adventures', '2026-01-25 17:30:00'),
    ('dmitry.sokolov@mail.com', 'Night Watch', '2026-04-18 22:00:00')
)
UPDATE viewing_history
SET watched_at = v.watched_at::timestamp
FROM v, users u, movies m
WHERE u.email = v.email
  AND m.title = v.title
  AND viewing_history.user_id = u.user_id
  AND viewing_history.movie_id = m.movie_id;

WITH v(email, title, review_date) AS (
    VALUES
    ('ivan.petrov@mail.com', 'Star Trek', '2026-01-06'),
    ('maria.smirnova@mail.com', 'Star Trek', '2026-06-07'),
    ('alex.kuznetsov@mail.com', 'Dark Side', '2026-03-15'),
    ('olga.volkova@mail.com', 'Space Flight', '2026-02-20'),
    ('dmitry.sokolov@mail.com', 'Cat''s Adventures', '2026-04-20')
)
UPDATE reviews
SET review_date = v.review_date::date
FROM v, users u, movies m
WHERE u.email = v.email
  AND m.title = v.title
  AND reviews.user_id = u.user_id
  AND reviews.movie_id = m.movie_id;

WITH v(email, registered_at) AS (
    VALUES
    ('ivan.petrov@mail.com', '2025-12-20'),
    ('maria.smirnova@mail.com', '2026-01-05'),
    ('alex.kuznetsov@mail.com', '2026-01-15'),
    ('olga.volkova@mail.com', '2025-12-28'),
    ('dmitry.sokolov@mail.com', '2026-02-01')
)
UPDATE users
SET registered_at = v.registered_at::date
FROM v
WHERE users.email = v.email;

INSERT INTO genres (name) VALUES ('Documentary');

INSERT INTO users (full_name, email, password_hash, birth_date, registered_at) VALUES
    ('Anna Belova', 'anna.belova@mail.com', 'hash6', '1993-06-14', '2026-01-10'),
    ('Sergey Orlov', 'sergey.orlov@mail.com', 'hash7', '1988-02-27', '2026-01-20'),
    ('Ekaterina Ivanova', 'ekaterina.ivanova@mail.com', 'hash8', NULL, '2026-02-03'),
    ('Pavel Morozov', 'pavel.morozov@mail.com', 'hash9', '2001-09-09', '2026-02-18'),
    ('Natalia Lebedeva', 'natalia.lebedeva@mail.com', 'hash10', '1996-12-01', '2026-02-25'),
    ('Artem Zaytsev', 'artem.zaytsev@mail.com', 'hash11', '1999-04-19', '2026-03-02'),
    ('Yulia Novikova', 'yulia.novikova@mail.com', 'hash12', NULL, '2026-03-10'),
    ('Roman Fedorov', 'roman.fedorov@mail.com', 'hash13', '1985-08-08', '2026-03-22'),
    ('Viktoria Popova', 'viktoria.popova@mail.com', 'hash14', '2003-03-03', '2026-04-07'),
    ('Maxim Kozlov', 'maxim.kozlov@mail.com', 'hash15', '1990-10-10', '2026-05-12');

WITH v(title, release_year, duration_minutes, rating, genre_name) AS (
    VALUES
    ('Last Frontier', 2020, 125, 8.4, 'Sci-Fi'),
    ('City of Shadows', 2019, 108, 7.7, 'Thriller'),
    ('House by the Lake', 2022, 97, 7.3, 'Drama'),
    ('Funny Company', 2021, 91, 6.9, 'Comedy'),
    ('Short Frame', 2024, 1, 7.0, 'Animation'),
    ('Fresh Release', 2025, 102, NULL, 'Comedy'),
    ('Failed Project', 2015, 88, 0.0, 'Drama'),
    ('Moonlit Night', 2023, 130, 8.8, 'Sci-Fi')
)
INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id)
SELECT v.title, v.release_year, v.duration_minutes, v.rating, g.genre_id
FROM v
JOIN genres g ON g.name = v.genre_name;

WITH v(email, plan_type, start_date, end_date, status) AS (
    VALUES
    ('ivan.petrov@mail.com', 'basic', '2026-02-01', '2026-03-01', 'expired'),
    ('ivan.petrov@mail.com', 'standard', '2026-03-01', '2026-04-01', 'expired'),
    ('ivan.petrov@mail.com', 'standard', '2026-04-01', '2026-05-01', 'expired'),
    ('ivan.petrov@mail.com', 'premium', '2026-06-01', '2026-07-01', 'active'),
    ('maria.smirnova@mail.com', 'premium', '2026-03-15', '2026-04-15', 'expired'),
    ('maria.smirnova@mail.com', 'premium', '2026-04-15', '2026-05-15', 'cancelled'),
    ('maria.smirnova@mail.com', 'basic', '2026-06-01', '2026-07-01', 'active'),
    ('alex.kuznetsov@mail.com', 'standard', '2026-04-01', '2026-05-01', 'expired'),
    ('alex.kuznetsov@mail.com', 'standard', '2026-05-01', '2026-06-01', 'expired'),
    ('alex.kuznetsov@mail.com', 'standard', '2026-06-01', '2026-07-01', 'active'),
    ('olga.volkova@mail.com', 'basic', '2026-02-10', '2026-03-10', 'expired'),
    ('olga.volkova@mail.com', 'basic', '2026-03-10', '2026-04-10', 'cancelled'),
    ('dmitry.sokolov@mail.com', 'premium', '2026-05-01', '2026-06-01', 'expired'),
    ('dmitry.sokolov@mail.com', 'premium', '2026-06-01', '2026-07-01', 'active'),
    ('anna.belova@mail.com', 'standard', '2026-01-15', '2026-02-15', 'expired'),
    ('anna.belova@mail.com', 'standard', '2026-02-15', '2026-03-15', 'expired'),
    ('anna.belova@mail.com', 'premium', '2026-03-15', '2026-04-15', 'cancelled'),
    ('sergey.orlov@mail.com', 'basic', '2026-02-05', '2026-03-05', 'expired'),
    ('sergey.orlov@mail.com', 'basic', '2026-05-10', '2026-06-10', 'expired'),
    ('ekaterina.ivanova@mail.com', 'premium', '2026-03-20', '2026-04-20', 'expired'),
    ('ekaterina.ivanova@mail.com', 'premium', '2026-05-20', '2026-06-20', 'active'),
    ('pavel.morozov@mail.com', 'basic', '2026-04-05', '2026-05-05', 'active'),
    ('natalia.lebedeva@mail.com', 'standard', '2026-03-05', '2026-04-05', 'expired'),
    ('natalia.lebedeva@mail.com', 'standard', '2026-04-05', '2026-05-05', 'active'),
    ('artem.zaytsev@mail.com', 'premium', '2026-04-10', '2026-05-10', 'active'),
    ('yulia.novikova@mail.com', 'basic', '2026-05-15', '2026-06-15', 'cancelled'),
    ('viktoria.popova@mail.com', 'standard', '2026-05-25', '2026-06-25', 'active'),
    ('maxim.kozlov@mail.com', 'premium', '2026-06-05', '2026-07-05', 'active')
)
INSERT INTO active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, v.start_date::date, v.end_date::date, v.status
FROM v
JOIN users u ON u.email = v.email
JOIN subscriptions p ON p.plan_type = v.plan_type;

WITH v(email, title, watched_at, progress) AS (
    VALUES
    ('ivan.petrov@mail.com', 'Last Frontier', '2026-01-12 20:15:00', 100),
    ('ivan.petrov@mail.com', 'Last Frontier', '2026-02-20 21:00:00', 100),
    ('ivan.petrov@mail.com', 'City of Shadows', '2026-04-10 19:40:00', 60),
    ('ivan.petrov@mail.com', 'Moonlit Night', '2026-06-03 22:30:00', 100),
    ('maria.smirnova@mail.com', 'Funny Company', '2026-03-20 18:00:00', 100),
    ('maria.smirnova@mail.com', 'House by the Lake', '2026-04-02 21:10:00', 35),
    ('maria.smirnova@mail.com', 'Space Flight', '2026-06-05 20:00:00', 100),
    ('maria.smirnova@mail.com', 'Star Trek', '2026-06-06 20:30:00', 90),
    ('alex.kuznetsov@mail.com', 'Star Trek', '2026-04-05 19:00:00', 100),
    ('alex.kuznetsov@mail.com', 'Last Frontier', '2026-04-12 20:00:00', 100),
    ('alex.kuznetsov@mail.com', 'Moonlit Night', '2026-05-03 22:00:00', 75),
    ('alex.kuznetsov@mail.com', 'Space Flight', '2026-06-02 21:30:00', 100),
    ('olga.volkova@mail.com', 'Cat''s Adventures', '2026-02-12 17:00:00', 100),
    ('olga.volkova@mail.com', 'Laughter Through Tears', '2026-03-14 20:20:00', 50),
    ('olga.volkova@mail.com', 'House by the Lake', '2026-03-15 21:00:00', 0),
    ('dmitry.sokolov@mail.com', 'Dark Side', '2026-05-03 22:10:00', 100),
    ('dmitry.sokolov@mail.com', 'City of Shadows', '2026-05-18 21:45:00', 100),
    ('dmitry.sokolov@mail.com', 'Moonlit Night', '2026-06-04 23:00:00', 100),
    ('anna.belova@mail.com', 'Laughter Through Tears', '2026-01-20 19:30:00', 100),
    ('anna.belova@mail.com', 'Funny Company', '2026-02-18 20:10:00', 100),
    ('anna.belova@mail.com', 'Night Watch', '2026-03-18 21:00:00', 40),
    ('anna.belova@mail.com', 'Dark Side', '2026-03-25 22:00:00', 100),
    ('sergey.orlov@mail.com', 'Space Flight', '2026-02-08 20:00:00', 100),
    ('sergey.orlov@mail.com', 'Star Trek', '2026-02-25 21:20:00', 100),
    ('sergey.orlov@mail.com', 'Last Frontier', '2026-05-12 20:40:00', 55),
    ('ekaterina.ivanova@mail.com', 'House by the Lake', '2026-03-22 18:30:00', 100),
    ('ekaterina.ivanova@mail.com', 'Laughter Through Tears', '2026-03-30 19:15:00', 100),
    ('ekaterina.ivanova@mail.com', 'Moonlit Night', '2026-05-22 22:20:00', 100),
    ('ekaterina.ivanova@mail.com', 'Space Flight', '2026-06-01 21:00:00', 30),
    ('pavel.morozov@mail.com', 'Night Watch', '2026-04-08 20:00:00', 100),
    ('pavel.morozov@mail.com', 'City of Shadows', '2026-04-25 21:30:00', 80),
    ('natalia.lebedeva@mail.com', 'Cat''s Adventures', '2026-03-08 16:45:00', 100),
    ('natalia.lebedeva@mail.com', 'Cat''s Adventures', '2026-03-15 17:00:00', 100),
    ('natalia.lebedeva@mail.com', 'Funny Company', '2026-04-10 19:50:00', 100),
    ('yulia.novikova@mail.com', 'House by the Lake', '2026-05-17 20:00:00', 20)
)
INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, v.watched_at::timestamp, v.progress
FROM v
JOIN users u ON u.email = v.email
JOIN movies m ON m.title = v.title;

WITH v(email, title, rating, comment, review_date) AS (
    VALUES
    ('ivan.petrov@mail.com', 'Last Frontier', 9, 'Strong plot', '2026-01-15'),
    ('ivan.petrov@mail.com', 'Moonlit Night', 10, NULL, '2026-06-04'),
    ('maria.smirnova@mail.com', 'Funny Company', 7, 'Light comedy', '2026-03-21'),
    ('maria.smirnova@mail.com', 'House by the Lake', 5, NULL, '2026-04-03'),
    ('alex.kuznetsov@mail.com', 'Last Frontier', 8, 'Good but predictable', '2026-04-13'),
    ('alex.kuznetsov@mail.com', 'Space Flight', 9, NULL, '2026-06-03'),
    ('olga.volkova@mail.com', 'Cat''s Adventures', 7, 'Kids liked it', '2026-02-13'),
    ('dmitry.sokolov@mail.com', 'Dark Side', 9, 'Tense until the end', '2026-05-04'),
    ('dmitry.sokolov@mail.com', 'City of Shadows', 8, NULL, '2026-05-19'),
    ('anna.belova@mail.com', 'Laughter Through Tears', 6, 'Humor is weak', '2026-01-21'),
    ('anna.belova@mail.com', 'Dark Side', 10, 'A masterpiece', '2026-03-26'),
    ('sergey.orlov@mail.com', 'Space Flight', 9, 'Beautiful space saga', '2026-02-09'),
    ('ekaterina.ivanova@mail.com', 'House by the Lake', 8, 'Warm story', '2026-03-23'),
    ('ekaterina.ivanova@mail.com', 'Moonlit Night', 9, NULL, '2026-05-23'),
    ('natalia.lebedeva@mail.com', 'Cat''s Adventures', 8, 'Watched as a family', '2026-03-16')
)
INSERT INTO reviews (user_id, movie_id, rating, comment, review_date)
SELECT u.user_id, m.movie_id, v.rating, v.comment, v.review_date::date
FROM v
JOIN users u ON u.email = v.email
JOIN movies m ON m.title = v.title;
