\echo '=== 1.1 Popularity rank of movies inside each genre (ties share a place, zero views kept) ==='

SELECT g.name AS genre,
       m.title,
       COUNT(vh.history_id) AS views_count,
       RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS rank_in_genre,
       DENSE_RANK() OVER (PARTITION BY g.genre_id ORDER BY COUNT(vh.history_id) DESC) AS dense_rank_in_genre,
       m.rating
FROM genres g
JOIN movies m ON m.genre_id = g.genre_id
LEFT JOIN viewing_history vh ON vh.movie_id = m.movie_id
GROUP BY g.genre_id, g.name, m.movie_id, m.title, m.rating
ORDER BY g.name, rank_in_genre, m.title;

\echo '=== 1.2 Gap between consecutive viewings of every user (first viewing kept) ==='

SELECT u.full_name,
       m.title,
       vh.watched_at,
       LAG(vh.watched_at) OVER w AS prev_watched_at,
       vh.watched_at::date - LAG(vh.watched_at::date) OVER w AS days_since_prev,
       LAG(m.title) OVER w AS prev_title
FROM viewing_history vh
JOIN users u ON u.user_id = vh.user_id
JOIN movies m ON m.movie_id = vh.movie_id
WINDOW w AS (PARTITION BY vh.user_id ORDER BY vh.watched_at, vh.history_id)
ORDER BY u.full_name, vh.watched_at, vh.history_id;

\echo '=== 1.3 Share of every paid subscription in the total spending of its user ==='

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
ORDER BY u.full_name, a.start_date, a.active_subscription_id;
