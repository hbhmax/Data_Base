INSERT INTO genres (name) VALUES ('Western');

INSERT INTO users (full_name, email, password_hash, birth_date, registered_at) VALUES
('Control Viewer One', 'control.one@mail.com', 'hash101', '1990-01-01', '2026-01-01'),
('Control Viewer Two', 'control.two@mail.com', 'hash102', '1991-02-02', '2026-01-01');

WITH v(title, release_year, duration_minutes, rating, genre_name) AS (
    VALUES
    ('Control Western A', 2020, 100, 7.0, 'Western'),
    ('Control Western B', 2020, 100, 7.0, 'Western'),
    ('Control Western C', 2020, 100, 6.0, 'Western'),
    ('Control Western D', 2020, 100, NULL, 'Western')
)
INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id)
SELECT v.title, v.release_year, v.duration_minutes, v.rating, g.genre_id
FROM v
JOIN genres g ON g.name = v.genre_name;

WITH v(email, plan_type, start_date, end_date, status) AS (
    VALUES
    ('control.one@mail.com', 'basic', '2026-01-01', '2026-02-01', 'expired'),
    ('control.one@mail.com', 'standard', '2026-02-01', '2026-03-01', 'expired'),
    ('control.one@mail.com', 'premium', '2026-03-01', '2026-04-01', 'expired'),
    ('control.one@mail.com', 'premium', '2026-04-01', '2026-05-01', 'cancelled'),
    ('control.two@mail.com', 'basic', '2026-04-01', '2026-05-01', 'expired')
)
INSERT INTO active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, v.start_date::date, v.end_date::date, v.status
FROM v
JOIN users u ON u.email = v.email
JOIN subscriptions p ON p.plan_type = v.plan_type;

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-03-01 10:00:00'::timestamp, 100
FROM users u
CROSS JOIN movies m
WHERE u.email = 'control.one@mail.com' AND m.title = 'Control Western A';

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-03-05 20:00:00'::timestamp, 100
FROM users u
CROSS JOIN movies m
WHERE u.email = 'control.one@mail.com' AND m.title = 'Control Western B';

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-03-05 20:00:00'::timestamp, 50
FROM users u
CROSS JOIN movies m
WHERE u.email = 'control.one@mail.com' AND m.title = 'Control Western C';

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-03-15 18:00:00'::timestamp, 100
FROM users u
CROSS JOIN movies m
WHERE u.email = 'control.one@mail.com' AND m.title = 'Control Western A';

WITH v(email, title, watched_at, progress) AS (
    VALUES
    ('control.two@mail.com', 'Control Western A', '2026-04-01 12:00:00', 100),
    ('control.two@mail.com', 'Control Western B', '2026-04-02 12:00:00', 100),
    ('control.two@mail.com', 'Control Western B', '2026-04-10 09:00:00', 80)
)
INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, v.watched_at::timestamp, v.progress
FROM v
JOIN users u ON u.email = v.email
JOIN movies m ON m.title = v.title;
