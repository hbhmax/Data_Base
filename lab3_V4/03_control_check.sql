\echo '=== CONTROL 1.1 (genre Western) ==='
\echo 'expected: A 3 views rank 1 dense 1 | B 3 views rank 1 dense 1 | C 1 view rank 3 dense 2 | D 0 views rank 4 dense 3 (rating NULL)'

SELECT g.name AS genre,
       m.title,
       COUNT(vh.history_id) AS views_count,
       RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS rank_in_genre,
       DENSE_RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS dense_rank_in_genre,
       m.rating
FROM genres g
JOIN movies m ON m.genre_id = g.genre_id
LEFT JOIN viewing_history vh ON vh.movie_id = m.movie_id
WHERE g.name = 'Western'
GROUP BY g.genre_id, g.name, m.movie_id, m.title, m.rating
ORDER BY rank_in_genre, m.title;

\echo '=== CONTROL 1.2 (control users) ==='
\echo 'expected One: A first (NULL) | B 4 days | C 0 days (same moment as B, order by history_id) | A 10 days. Two: A first (NULL) | B 1 day | B 8 days'

SELECT u.full_name,
       m.title,
       vh.watched_at,
       LAG(vh.watched_at) OVER w AS prev_watched_at,
       vh.watched_at::date - LAG(vh.watched_at::date) OVER w AS days_since_prev,
       LAG(m.title) OVER w AS prev_title
FROM viewing_history vh
JOIN users u ON u.user_id = vh.user_id
JOIN movies m ON m.movie_id = vh.movie_id
WHERE u.email LIKE 'control.%'
WINDOW w AS (PARTITION BY vh.user_id ORDER BY vh.watched_at, vh.history_id)
ORDER BY u.full_name, vh.watched_at, vh.history_id;

\echo '=== CONTROL 1.3 (control users) ==='
\echo 'expected One: basic 299.99 15.8 | standard 599.99 31.6 | premium 999.99 52.6 (total 1899.97, cancelled excluded). Two: basic 299.99 100.0'

SELECT u.full_name,
       p.plan_type,
       a.start_date,
       p.price,
       SUM(p.price) OVER (PARTITION BY a.user_id) AS user_total,
       ROUND(100.0 * p.price / SUM(p.price) OVER (PARTITION BY a.user_id), 1) AS share_percent
FROM active_subscriptions a
JOIN users u ON u.user_id = a.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id
WHERE a.status <> 'cancelled'
  AND u.email LIKE 'control.%'
ORDER BY u.full_name, a.start_date, a.active_subscription_id;
