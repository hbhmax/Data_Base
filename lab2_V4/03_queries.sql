\echo '=== 2.1.1 JOIN: viewing details (users, viewing_history, movies, genres) ==='

SELECT u.full_name, m.title, g.name AS genre, vh.watched_at, vh.progress_percent
FROM viewing_history vh
JOIN users u ON u.user_id = vh.user_id
JOIN movies m ON m.movie_id = vh.movie_id
JOIN genres g ON g.genre_id = m.genre_id
ORDER BY vh.watched_at DESC;

\echo '=== 2.1.2 LEFT JOIN: movies that nobody watched and nobody reviewed ==='

SELECT m.title, g.name AS genre, m.release_year
FROM movies m
JOIN genres g ON g.genre_id = m.genre_id
LEFT JOIN viewing_history vh ON vh.movie_id = m.movie_id
LEFT JOIN reviews r ON r.movie_id = m.movie_id
WHERE vh.history_id IS NULL AND r.review_id IS NULL
ORDER BY m.title;

\echo '=== 2.1.3 JOIN: active subscribers who fully watched a movie with rating above 8 ==='

SELECT DISTINCT u.full_name, u.email, p.plan_type, m.title, m.rating
FROM users u
JOIN active_subscriptions a ON a.user_id = u.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id
JOIN viewing_history vh ON vh.user_id = u.user_id
JOIN movies m ON m.movie_id = vh.movie_id
WHERE a.status = 'active'
  AND vh.progress_percent = 100
  AND m.rating > 8
ORDER BY u.full_name, m.title;

\echo '=== 2.2.1 GROUP BY: indicators for each genre ==='

SELECT g.name AS genre,
       COUNT(m.movie_id) AS movies_count,
       ROUND(AVG(m.rating), 2) AS avg_rating,
       MIN(m.duration_minutes) AS min_duration,
       MAX(m.duration_minutes) AS max_duration
FROM genres g
LEFT JOIN movies m ON m.genre_id = g.genre_id
GROUP BY g.name
ORDER BY movies_count DESC, g.name;

\echo '=== 2.2.2 GROUP BY + HAVING: users who paid more than 1500 ==='

SELECT u.full_name,
       COUNT(a.active_subscription_id) AS subs_count,
       SUM(p.price) AS total_paid,
       ROUND(AVG(p.price), 2) AS avg_price,
       MAX(a.end_date) AS last_end_date
FROM users u
JOIN active_subscriptions a ON a.user_id = u.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id
WHERE a.status <> 'cancelled'
GROUP BY u.user_id, u.full_name
HAVING SUM(p.price) > 1500
ORDER BY total_paid DESC;

\echo '=== 2.2.3 GROUP BY: comparison of months ==='

SELECT TO_CHAR(a.start_date, 'YYYY-MM') AS period,
       COUNT(*) AS subs_started,
       COUNT(*) FILTER (WHERE a.status = 'cancelled') AS subs_cancelled,
       SUM(p.price) FILTER (WHERE a.status <> 'cancelled') AS revenue,
       ROUND(AVG(p.price), 2) AS avg_price
FROM active_subscriptions a
JOIN subscriptions p ON p.subscription_id = a.subscription_id
GROUP BY TO_CHAR(a.start_date, 'YYYY-MM')
ORDER BY period;

\echo '=== 3.1 Subquery: movies with rating above the average of their genre ==='

SELECT m.title, g.name AS genre, m.rating, ROUND(ga.avg_rating, 2) AS genre_avg_rating
FROM movies m
JOIN genres g ON g.genre_id = m.genre_id
JOIN (
    SELECT genre_id, AVG(rating) AS avg_rating
    FROM movies
    GROUP BY genre_id
) ga ON ga.genre_id = m.genre_id
WHERE m.rating > ga.avg_rating
ORDER BY g.name, m.rating DESC;

\echo '=== 3.2 EXISTS: users who have at least one cancelled premium subscription ==='

SELECT u.full_name, u.email
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM active_subscriptions a
    JOIN subscriptions p ON p.subscription_id = a.subscription_id
    WHERE a.user_id = u.user_id
      AND p.plan_type = 'premium'
      AND a.status = 'cancelled'
)
ORDER BY u.full_name;

\echo '=== 3.3 NOT EXISTS: active subscribers who never watched anything ==='

SELECT u.full_name, u.email, p.plan_type, a.end_date
FROM users u
JOIN active_subscriptions a ON a.user_id = u.user_id
JOIN subscriptions p ON p.subscription_id = a.subscription_id
WHERE a.status = 'active'
  AND NOT EXISTS (
    SELECT 1
    FROM viewing_history vh
    WHERE vh.user_id = u.user_id
)
ORDER BY u.full_name;

\echo '=== 3.4 Correlated subquery: personal indicators of every user ==='

SELECT u.full_name,
       (SELECT COUNT(*)
        FROM viewing_history vh
        WHERE vh.user_id = u.user_id AND vh.progress_percent = 100) AS finished_movies,
       (SELECT MAX(a.end_date)
        FROM active_subscriptions a
        WHERE a.user_id = u.user_id) AS last_subscription_end,
       (SELECT ROUND(AVG(r.rating), 1)
        FROM reviews r
        WHERE r.user_id = u.user_id) AS avg_given_rating
FROM users u
ORDER BY finished_movies DESC, u.full_name;

\echo '=== 4 CTE report: revenue and activity by plan ==='

WITH user_revenue AS (
    SELECT a.user_id,
           a.subscription_id,
           COUNT(*) AS subs_count,
           SUM(p.price) AS paid
    FROM active_subscriptions a
    JOIN subscriptions p ON p.subscription_id = a.subscription_id
    WHERE a.status <> 'cancelled'
    GROUP BY a.user_id, a.subscription_id
),
user_activity AS (
    SELECT user_id,
           COUNT(*) AS views_count,
           AVG(progress_percent) AS avg_progress,
           COUNT(*) FILTER (WHERE progress_percent = 100) AS finished_count
    FROM viewing_history
    GROUP BY user_id
),
user_report AS (
    SELECT r.subscription_id,
           r.user_id,
           r.paid,
           COALESCE(a.views_count, 0) AS views_count,
           COALESCE(a.avg_progress, 0) AS avg_progress
    FROM user_revenue r
    LEFT JOIN user_activity a ON a.user_id = r.user_id
),
plan_report AS (
    SELECT p.plan_type,
           COUNT(ur.user_id) AS paying_users,
           COALESCE(SUM(ur.paid), 0) AS revenue,
           AVG(ur.views_count) AS avg_views,
           AVG(ur.avg_progress) AS avg_progress,
           COUNT(*) FILTER (WHERE ur.views_count = 0) AS users_without_views
    FROM subscriptions p
    LEFT JOIN user_report ur ON ur.subscription_id = p.subscription_id
    GROUP BY p.plan_type
)
SELECT plan_type,
       paying_users,
       revenue,
       ROUND(revenue / NULLIF(paying_users, 0), 2) AS revenue_per_user,
       ROUND(avg_views, 1) AS avg_views,
       ROUND(avg_progress, 1) AS avg_progress,
       users_without_views,
       ROUND(100.0 * users_without_views / NULLIF(paying_users, 0), 1) AS inactive_percent,
       CASE
           WHEN paying_users = 0 THEN 'NO BUYERS'
           WHEN 100.0 * users_without_views / paying_users >= 20 THEN 'RISK'
           ELSE 'OK'
       END AS verdict
FROM plan_report
ORDER BY revenue DESC, plan_type;
