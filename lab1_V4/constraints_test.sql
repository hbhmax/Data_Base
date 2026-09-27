INSERT INTO users (full_name, email, password_hash) VALUES
('Тестовый Пользователь', 'ivan.petrov@mail.com', 'hash6');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Некорректный фильм', 2020, -50, 7.0, 1);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(2, 2, 15, 'Слишком высокая оценка');

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(1, 'basic', '2026-05-01', '2026-04-01', 299.00);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(1, 1, 5, 'Повторный отзыв на тот же фильм');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Фильм без жанра', 2020, 100, 7.0, 999);

INSERT INTO users (full_name, email, password_hash) VALUES
('Пользователь без почты', NULL, 'hash7');

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(2, 'vip', '2026-05-01', '2026-06-01', 999.00);
