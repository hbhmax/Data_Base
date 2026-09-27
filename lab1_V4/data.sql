INSERT INTO genres (name) VALUES
('Драма'),
('Комедия'),
('Фантастика'),
('Триллер'),
('Мультфильм');

INSERT INTO users (full_name, email, password_hash, birth_date) VALUES
('Иван Петров', 'ivan.petrov@mail.com', 'hash1', '1995-03-12'),
('Мария Смирнова', 'maria.smirnova@mail.com', 'hash2', '1998-07-22'),
('Алексей Кузнецов', 'alex.kuznetsov@mail.com', 'hash3', '2000-01-05'),
('Ольга Волкова', 'olga.volkova@mail.com', 'hash4', '1992-11-30'),
('Дмитрий Соколов', 'dmitry.sokolov@mail.com', 'hash5', '1997-05-18');

INSERT INTO movies (title, release_year, duration_minutes, rating, genre_id) VALUES
('Звёздный путь', 2019, 135, 8.2, 3),
('Смех сквозь слёзы', 2020, 102, 7.1, 2),
('Тёмная сторона', 2018, 118, 8.9, 4),
('Простая история', 2021, 95, 6.8, 1),
('Космический рейс', 2022, 140, 9.0, 3),
('Приключения кота', 2017, 80, 7.5, 5),
('Ночной дозор', 2016, 110, 7.9, 4),
('Летний дождь', 2023, 99, 6.5, 1);

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, price) VALUES
(1, 'basic', '2026-01-01', '2026-02-01', 299.00),
(2, 'premium', '2026-02-15', '2026-03-15', 799.00),
(3, 'standard', '2026-03-01', '2026-04-01', 499.00),
(4, 'basic', '2026-01-10', '2026-02-10', 299.00),
(5, 'premium', '2026-04-01', '2026-05-01', 799.00);

INSERT INTO reviews (user_id, movie_id, rating, comment) VALUES
(1, 1, 9, 'Очень понравилось'),
(2, 1, 7, 'Неплохо, но затянуто'),
(3, 3, 10, 'Лучший триллер года'),
(4, 5, 8, 'Отличная графика'),
(5, 6, 6, 'Средне');

INSERT INTO viewing_history (user_id, movie_id, progress_percent) VALUES
(1, 1, 100),
(1, 2, 45),
(2, 3, 100),
(3, 5, 80),
(4, 6, 30),
(5, 7, 100);
