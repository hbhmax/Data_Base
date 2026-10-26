\echo '=== 1.2.1 INSERT: new user and related records ==='

INSERT INTO users (full_name, email, password_hash, birth_date)
VALUES ('Gleb Tikhonov', 'gleb.tikhonov@mail.com', 'hash16', '1994-07-07');

INSERT INTO active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, '2026-06-10'::date, '2026-07-10'::date, 'active'
FROM users u
CROSS JOIN subscriptions p
WHERE u.email = 'gleb.tikhonov@mail.com' AND p.plan_type = 'standard';

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-06-11 20:00:00'::timestamp, 100
FROM users u
CROSS JOIN movies m
WHERE u.email = 'gleb.tikhonov@mail.com' AND m.title = 'Moonlit Night';

INSERT INTO reviews (user_id, movie_id, rating, comment)
SELECT u.user_id, m.movie_id, 9, 'Great movie'
FROM users u
CROSS JOIN movies m
WHERE u.email = 'gleb.tikhonov@mail.com' AND m.title = 'Moonlit Night';

SELECT u.email, p.plan_type, a.status, vh.progress_percent, r.rating
FROM users u
JOIN active_subscriptions a ON a.user_id = u.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id
JOIN viewing_history vh ON vh.user_id = u.user_id
JOIN reviews r ON r.user_id = u.user_id
WHERE u.email = 'gleb.tikhonov@mail.com';

\echo '=== 1.2.2 UPDATE: cancel one subscription ==='

UPDATE active_subscriptions
SET status = 'cancelled'
WHERE user_id = (SELECT user_id FROM users WHERE email = 'maria.smirnova@mail.com')
  AND status = 'active'
RETURNING active_subscription_id, user_id, status;

\echo '=== 1.2.3 UPDATE: bulk close subscriptions that already ended ==='

UPDATE active_subscriptions
SET status = 'expired'
WHERE status = 'active' AND end_date < '2026-06-15'::date
RETURNING active_subscription_id, user_id, end_date, status;

SELECT status, COUNT(*) AS subs_count
FROM active_subscriptions
GROUP BY status
ORDER BY status;

\echo '=== 1.2.4 DELETE: review, user with CASCADE, genre with RESTRICT ==='

DELETE FROM reviews
WHERE comment IS NULL AND rating < 6
RETURNING review_id, user_id, movie_id, rating;

SELECT (SELECT COUNT(*) FROM active_subscriptions) AS subs_before,
       (SELECT COUNT(*) FROM viewing_history) AS views_before;

DELETE FROM users WHERE email = 'yulia.novikova@mail.com';

SELECT (SELECT COUNT(*) FROM active_subscriptions) AS subs_after,
       (SELECT COUNT(*) FROM viewing_history) AS views_after;

\echo '--- the next DELETE must fail: genre is used by movies (ON DELETE RESTRICT) ---'

DELETE FROM genres WHERE name = 'Sci-Fi';

\echo '=== 1.2.5 ROLLBACK: undo changes ==='

BEGIN;

DELETE FROM subscriptions WHERE plan_type = 'basic';
DELETE FROM viewing_history;

SELECT (SELECT COUNT(*) FROM active_subscriptions) AS subs_inside,
       (SELECT COUNT(*) FROM viewing_history) AS views_inside;

ROLLBACK;

SELECT (SELECT COUNT(*) FROM active_subscriptions) AS subs_after_rollback,
       (SELECT COUNT(*) FROM viewing_history) AS views_after_rollback;
