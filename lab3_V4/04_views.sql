\echo '=== 2.1 Operational view: list of subscriptions with user and plan ==='

CREATE VIEW v_subscription_details AS
SELECT a.active_subscription_id,
       u.user_id,
       u.full_name,
       u.email,
       p.plan_type,
       p.price,
       a.start_date,
       a.end_date,
       a.status
FROM active_subscriptions a
JOIN users u ON u.user_id = a.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id;

\echo '--- before the change ---'

SELECT plan_type, price, start_date, end_date, status
FROM v_subscription_details
WHERE email = 'alex.kuznetsov@mail.com'
ORDER BY start_date;

BEGIN;

UPDATE active_subscriptions
SET status = 'cancelled'
WHERE user_id = (SELECT user_id FROM users WHERE email = 'alex.kuznetsov@mail.com')
  AND status = 'active';

INSERT INTO active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, '2026-07-01'::date, '2026-08-01'::date, 'active'
FROM users u
CROSS JOIN subscriptions p
WHERE u.email = 'alex.kuznetsov@mail.com' AND p.plan_type = 'premium';

\echo '--- after the change (same view, nothing was rebuilt) ---'

SELECT plan_type, price, start_date, end_date, status
FROM v_subscription_details
WHERE email = 'alex.kuznetsov@mail.com'
ORDER BY start_date;

ROLLBACK;

\echo '--- after ROLLBACK ---'

SELECT plan_type, price, start_date, end_date, status
FROM v_subscription_details
WHERE email = 'alex.kuznetsov@mail.com'
ORDER BY start_date;

\echo '=== 2.2 Analytical view: movie popularity inside genres (query 1.1) ==='

CREATE VIEW v_movie_popularity AS
SELECT g.genre_id,
       g.name AS genre,
       m.movie_id,
       m.title,
       m.rating,
       COUNT(vh.history_id) AS views_count,
       RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS rank_in_genre,
       DENSE_RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS dense_rank_in_genre
FROM genres g
JOIN movies m ON m.genre_id = g.genre_id
LEFT JOIN viewing_history vh ON vh.movie_id = m.movie_id
GROUP BY g.genre_id, g.name, m.movie_id, m.title, m.rating;

\echo '--- the view used in another query: top 2 places of every genre and distance from the genre average ---'

SELECT p.genre,
       p.title,
       p.views_count,
       p.rank_in_genre,
       ROUND(p.views_count - ga.avg_views, 2) AS diff_from_genre_avg
FROM v_movie_popularity p
JOIN (
    SELECT genre, AVG(views_count) AS avg_views
    FROM v_movie_popularity
    GROUP BY genre
) ga ON ga.genre = p.genre
WHERE p.rank_in_genre <= 2
  AND p.views_count > 0
ORDER BY p.genre, p.rank_in_genre, p.title;

\echo '=== 2.3 Updatable view with WITH CHECK OPTION: only active subscriptions ==='

CREATE VIEW v_active_subscriptions AS
SELECT active_subscription_id, user_id, subscription_id, start_date, end_date, status
FROM active_subscriptions
WHERE status = 'active'
WITH CHECK OPTION;

\echo '--- allowed: extend the subscription by 30 days and add a new active one (rolled back afterwards) ---'

BEGIN;

UPDATE v_active_subscriptions
SET end_date = end_date + 30
WHERE user_id = (SELECT user_id FROM users WHERE email = 'alex.kuznetsov@mail.com')
RETURNING active_subscription_id, start_date, end_date, status;

INSERT INTO v_active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, '2026-07-01'::date, '2026-08-01'::date, 'active'
FROM users u
CROSS JOIN subscriptions p
WHERE u.email = 'alex.kuznetsov@mail.com' AND p.plan_type = 'basic'
RETURNING active_subscription_id, start_date, end_date, status;

ROLLBACK;

\echo '--- the next UPDATE must fail: it would move the row out of the view (status is not active) ---'

UPDATE v_active_subscriptions
SET status = 'cancelled'
WHERE user_id = (SELECT user_id FROM users WHERE email = 'alex.kuznetsov@mail.com');

\echo '--- the next INSERT must fail: new row does not satisfy status = active ---'

INSERT INTO v_active_subscriptions (user_id, subscription_id, start_date, end_date, status)
SELECT u.user_id, p.subscription_id, '2026-07-01'::date, '2026-08-01'::date, 'expired'
FROM users u
CROSS JOIN subscriptions p
WHERE u.email = 'alex.kuznetsov@mail.com' AND p.plan_type = 'basic';

\echo '--- the data is unchanged ---'

SELECT status, COUNT(*) AS subs_count
FROM active_subscriptions
WHERE user_id = (SELECT user_id FROM users WHERE email = 'alex.kuznetsov@mail.com')
GROUP BY status
ORDER BY status;
