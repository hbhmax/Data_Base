\echo '=== 3 Materialized view: monthly statistics of genres ==='

CREATE MATERIALIZED VIEW mv_monthly_genre_stats AS
SELECT TO_CHAR(vh.watched_at, 'YYYY-MM') AS period,
       g.genre_id,
       g.name AS genre,
       COUNT(*) AS views_count,
       COUNT(DISTINCT vh.user_id) AS unique_viewers,
       ROUND(AVG(vh.progress_percent), 1) AS avg_progress,
       COUNT(*) FILTER (WHERE vh.progress_percent = 100) AS finished_views
FROM viewing_history vh
JOIN movies m ON m.movie_id = vh.movie_id
JOIN genres g ON g.genre_id = m.genre_id
GROUP BY TO_CHAR(vh.watched_at, 'YYYY-MM'), g.genre_id, g.name;

CREATE UNIQUE INDEX idx_mv_monthly_genre_stats ON mv_monthly_genre_stats (period, genre_id);

SELECT period, genre, views_count, unique_viewers, avg_progress, finished_views
FROM mv_monthly_genre_stats
ORDER BY period, genre;

\echo '--- usage: genres of March by number of views (reads stored rows, no recalculation) ---'

SELECT genre, views_count, unique_viewers
FROM mv_monthly_genre_stats
WHERE period = '2026-03'
ORDER BY views_count DESC, genre;

\echo '=== 4 Data freshness: the stored result lags behind until REFRESH ==='

BEGIN;

INSERT INTO viewing_history (user_id, movie_id, watched_at, progress_percent)
SELECT u.user_id, m.movie_id, '2026-06-20 21:00:00'::timestamp, 100
FROM users u
CROSS JOIN movies m
WHERE u.email = 'ivan.petrov@mail.com' AND m.title = 'Moonlit Night';

\echo '--- new viewing added, view not refreshed yet (the numbers differ) ---'

SELECT (SELECT COUNT(*) FROM viewing_history) AS source_views,
       (SELECT SUM(views_count) FROM mv_monthly_genre_stats) AS mv_views;

REFRESH MATERIALIZED VIEW mv_monthly_genre_stats;

\echo '--- after REFRESH (the numbers are equal) ---'

SELECT (SELECT COUNT(*) FROM viewing_history) AS source_views,
       (SELECT SUM(views_count) FROM mv_monthly_genre_stats) AS mv_views;

ROLLBACK;

\echo '--- after ROLLBACK everything is back (demo does not change the data) ---'

SELECT (SELECT COUNT(*) FROM viewing_history) AS source_views,
       (SELECT SUM(views_count) FROM mv_monthly_genre_stats) AS mv_views;

\echo '--- the commands of the update policy (see README, part 4) ---'
\echo 'nightly:  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_monthly_genre_stats;'
\echo 'manual:   REFRESH MATERIALIZED VIEW mv_monthly_genre_stats;'
